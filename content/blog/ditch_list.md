---
title: "Ditch List, use Dict in Python"
date: 2019-11-04T11:56:35+05:30
image: "images/blog/post-2.jpg"
description: "This is meta description."
author: "PK"
type: "post"
tags: ["python", "dict", "list", "hash"]
categories: ["technology", "programming"]
---

So, one day I was using too much list & wondered why we can’t use dict all the time when it has O(1) time complexity.
Instead of pondering I tried to measure things myself & see. I ended up measuring access time in a dict & in a list. Below is the code.

```python
import time

d = dict()
for i in range(10000000):
	d[i] = True

e = list()
for i in range(10000000):
	e.append(i)

t1 = time.time()
print("Found :)" if 45423 in d else "Not found :(")
t2 = time.time()
print("Time taken by dict : ", (t2 - t1))


t1 = time.time()
print("Found :)" if 45423 in e else "Not found :(")
t2 = time.time()
print("Time taken by list : ", (t2 - t1))
```

Now time to decide the winner and the results are as follows.

```bash
C:\Users\pankaj.kum\Documents\python-scripts>python dict_vs_list.py
Found :)
Time taken by dict :  0.0
Found :)
Time taken by list :  0.0009982585906982422

C:\Users\pankaj.kum\Documents\python-scripts>python dict_vs_list.py
Found :)
Time taken by dict :  0.0
Found :)
Time taken by list :  0.0010042190551757812

C:\Users\pankaj.kum\Documents\python-scripts>python dict_vs_list.py
Found :)
Time taken by dict :  0.0
Found :)
Time taken by list :  0.0009982585906982422

C:\Users\pankaj.kum\Documents\python-scripts>python dict_vs_list.py
Found :)
Time taken by dict :  0.0
Found :)
Time taken by list :  0.0010023117065429688
```

Dict takes very less time ~ 0 seconds.
So, dict or hashed map of unordered type should be convenient to use wherever you have large accessing over an array of elements. But, how to use it.
Lets assume you have list of numbers to take care of like `[1, 1, 2, 3, 5, 8]`. No cookies for guessing it's Fibonacci numbers.

```python
# Usual approach
fibList = list()
fibList.append(1)
fibList.append(1)
fibList.append(2)
fibList.append(3)
fibList.append(5)
fibList.append(8)
# You can generate it using any simple looping as well

# Dict approach
fibDict = dict()
fibDict[1] = True
fibDict[1] = True
fibDict[2] = True
fibDict[3] = True
fibDict[5] = True
fibDict[8] = True
# Assign the lightweight True or anything throwaway
```

I wonder why we don’t use it all the time & ditch list straight away. Here’s the catch.

> Whenever the order or permutation of numbers is super important & can’t be accepted in any haphazard order we use list instead of dict.

So, why did I suggested it in first place. Well, there are instances in your life when you have to travel by speed of life through your data structure & you don’t give a damn which piece of it was first.

Python dict or any language’s associative array uses a hash function which calculates address for storing. You store it there & wherever you demand for the stored value using its key the address is calculated (which is a [one to one function](https://en.wikipedia.org/wiki/Injective_function)). You directly go to the required memory location instead of looking all through the data structure. Blazing fast !

Well, what if I need to access it very fast & persist the order at the same time.

# Use trees

Trees are data structures which give search `O(log(n))` time complexity for searching throughout the data structure.
More specifically self balancing trees like the Red black trees.
That comes out of the box with `C++ STL in std::map`. I think you’ll have to implement something like this yourself when using python. Tell me if I am wrong or missing something.
