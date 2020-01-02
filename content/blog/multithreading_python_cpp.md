---
title: "Multithreading in C++ & Python"
date: 2019-12-09T10:12:54+05:30
image: "images/blog/post-4.jpg"
description: "This is meta description."
author: "PK"
type: "post"
tags: ["c++", "python", "threads"]
categories: ["technology", "programming"]
---


# Is Multithreading really useful
> **Thread** - In computer science, a thread of execution is the smallest sequence of programmed instructions that can be managed independently by a scheduler... (source : Wikipedia)
So, When you divide a program into independently managed pieces of work which can be later combined to have a correct end solution we divide it into chunks called threads.

But why do we need threads anyway?

Suppose we have a single processor sweating out for all the load. Now, if some part of program is very time consuming (eg. I/O bound routines) the code below that part will have to wait for it's completion for no specific reason as the below code can be logically independent than the first one.

Threads come to rescue. We will divide the program into independently managed routines. And their is a watchman standing near the hardworking CPU to disallow time consuming tasks. The watchman will prempt or kick out threads which waste precious CPU time & allow the deserving threads to be run so that CPU remains occupied most of the time.

Things were going well with mankind untill more demand came. Codes wanted to churn more data & computer manufactures didn't had a choice but to follow Moore's law. They added more workers (processors) on a single computer. Now, adding them was cheaper but utilizing them was a task for the old watchman. So, new watchmen were hired to handle the chaos (several scheduling paradigms were used).

Simply said, the threads were now spread up in multiple queues to multiple processors minimising overheads.

# C++ threads
With `pthreads.h` library in Clang things were in premitive stage untill C++ 11 had it's own threading library `<threads>`. Threading in C++ is very similar to what has been described above.

## Sequential program without any threading
```c++
    // thread example
    #include <iostream>       // std::cout
    #include <chrono>
    #include <unistd.h>
    using namespace std;
    using namespace std::chrono;

    void foo() {
      int sum = 0;
      for (int i = 0; i < 1000000; i++) {
        sum += i;
      }
      usleep(2000);
      cout << sum << endl;
    }

    void bar(int x) {
      int sum = 0;
      for (int i = 0; i < 1000000; i++) {
        sum += i;
        sum *= x;
      }
      usleep(1000);
      cout << sum << endl;
    }

    int main() {

      // Get starting timepoint
      auto start = high_resolution_clock::now();

      foo();
      bar(10);

      // Get ending timepoint
      auto stop = high_resolution_clock::now();

      auto duration = duration_cast < microseconds > (stop - start);

      cout << "Time taken by function: " <<
        duration.count() << " microseconds" << endl;

      return 0;
    }
```
```shell
> Time taken by function: 4783 microseconds
```

## Using threads for the same program
```c++
/ thread example#include <iostream>       // std::cout
#include <thread>         // std::thread
#include <chrono>
#include <unistd.h>
using namespace std;
using namespace std::chrono;

void foo() {
  int sum = 0;
  for (int i = 0; i < 1000000; i++) {
    sum += i;
  }
  usleep(2000);
  cout << sum << endl;
}

void bar(int x) {
  int sum = 0;
  for (int i = 0; i < 1000000; i++) {
    sum += i;
    sum *= x;
  }
  usleep(1000);
  cout << sum << endl;
}

int main() {

  // Get starting timepoint
  auto start = high_resolution_clock::now();

  thread first(foo); // spawn new thread that calls foo()
  thread second(bar, 10); // spawn new thread that calls bar(0)

  cout << "main, foo and bar now execute concurrently...\n";

  // synchronize threads:
  first.join(); // pauses until first finishes
  second.join(); // pauses until second finishes

  // Get ending timepoint
  auto stop = high_resolution_clock::now();

  auto duration = duration_cast < microseconds > (stop - start);

  cout << "Time taken by function: " <<
    duration.count() << " microseconds" << endl;

  return 0;
}
```
```shell
> Time taken by function: 3733 microseconds
```

> So, multithreading surely helps in heavy lifting tasks. But, for small programs & large CPU bound programs with very less I/O tasks will show no major breakthrough.


# Python threads
Python has weird problems. One of them is multithreading. It supports threading of a program using `threading`. But you can't use multi processor queues using threads. So, does that mean multiprocessing is not supported with such a hot and modern programmming language. Well, it has another module `multiprocessing` to do so.
(Cool explation of using threading in python)[https://www.guru99.com/python-multithreading-gil-example.html]

But still, a program divided into several threads can be more responsive running on a single core as comapred to sequential program. This is attributed to the fact that you always try to keep the CPU as busy as possible when multithreading. Sounds good for single processor.

Let's see some action now.
## Sequential program without any threading
```python
import threading
import time
def calc_square(number):
	print('Square:' , number * number)
	for i in range(1000000):
		number *= i
def calc_quad(number):
	print('Quad:' , number * number * number * number)
	for i in range(1000000):
		number *= i
if __name__ == "__main__":
	number = 7
	t1 = time.time()
	calc_square(number)
	calc_quad(number)
	t2 = time.time()
	print("Time : ", (t2 - t1)*1000)
```

```shell
> Time :  164.58821296691895
```

## Using threads for the same program
```python
import threading
import time
def calc_square(number):
	print('Square:' , number * number)
	for i in range(1000000):
		number *= i
def calc_quad(number):
	print('Quad:' , number * number * number * number)
	for i in range(1000000):
		number *= i
if __name__ == "__main__":
	number = 7

thread1 = threading.Thread(target=calc_square, args=(number,))
thread2 = threading.Thread(target=calc_quad, args=(number,))# Will execute both in parallel

t1 = time.time()
thread1.start()
thread2.start()# Joins threads back to the parent process, which is this
	# program
thread1.join()
thread2.join()# This program reduces the time of execution by running tasks in parallel
t2 = time.time()
print("Time : ", (t2 - t1)*1000)
```

```shell
Time :  171.08392715454102
```

> Multithreading is slower than sequencial code. That was kind of expected since all our code was running on single core. But don't undersestimate python, it has `multiprocessing` to offer.


We'll explore multiprocessing some other day.
