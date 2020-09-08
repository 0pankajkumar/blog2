+++ 
date = "2020-09-08"
title = "Migrating from Blogger / Blogspot to Hugo"
slug = "migrating-from-blogger-blogspot-to-hugo" 
tags = ["blogging", "blogger", "hugo", "migration"]
categories = ["technology"]
series = []
+++

## Migrating from Blogger / Blogspot to Hugo

Enough of blogger now. It's a good and complete platform but I always want to try newer things. So, I have decided to move my 5-6 year old blog posts to Hugo. There are some 50 posts, I don't write a lot, but that's my treasure.

Currently, it'll be hosted on Github with free domain provided but that shall improve in some time.

### Steps
1. Download or export the XML from blogger.com which will have all the blogs.

2. Convert the XML file into Markdown or .md format using [Blogimport](https://github.com/natefinch/blogimport) tool or choose from [this list](https://gohugo.io/tools/migrations/).
The tool is really basic, you just pass it the name of the file you're converting, the directory in which to output the markdown files.
Example:
`go run main.go blog-09-06-2020.xml /output`

And ofcourse you need to have [golang](https://golang.org/) to do that.

3. Once all Markdown files are generated a lot of work is done. But you'll notice that body of the blog is still HTML and nested HTML is not rendered by Hugo. It's such a bad thing.

4. Convert HTML to Markdown syntax using some tool.
I have used `markdownify`. Thanks to [brianli](https://brianli.com/python-convert-html-markdown/).
	* Just install `markdownify` like this
```
pip install markdownify
```
And start using like this
```
from markdownify import markdownify

html = markdownify("<h1>Hugo is fast!</h1>")

print(html)

# Hugo is fast!
# ===========
```

But you'll have to manually separate the html from markdown files generated above. I wrote a python script to automate that.
```
import os
import glob
from markdownify import markdownify

pathToRead = '/home/pankaj/Documents/blogimport/posts'
pathToWrite = '/home/pankaj/Documents/blogimport/posts_cleaned'

def seperateHTML(rawText):
	startOfTOML = 1
	"""
	1: just started, 2: reading TOML, 3: Done with TOML
	"""
	tomlLines = list()
	htmlLines = list()

	for r in rawText:
		if r == "+++\n":
			if startOfTOML == 1:
				startOfTOML = 2
			elif startOfTOML == 2:
				startOfTOML = 3
				tomlLines.append(r)
				continue

		if startOfTOML == 2:
			tomlLines.append(r)

		if startOfTOML == 3:
			htmlLines.append(r)

	return ''.join(tomlLines), ''.join(htmlLines)




for filename in glob.glob(os.path.join(pathToRead, '*.md')):
	with open(filename, 'r') as f:
		entireText = f.readlines()
		tomlLines, htmlLines = seperateHTML(entireText)

		try:
			htmlLines = markdownify(htmlLines)
		except:
			htmlLines = htmlLines

		fileNameToWrite = f.name.split('/')[-1]

		with open(os.path.join(pathToWrite, fileNameToWrite), "w") as fr:
			print("writing to file")
			fr.write(tomlLines)
			fr.write(htmlLines)

```
This will convert most of the files & write it into the folder specified. Make sure to modify the paths (pathToRead, pathToWrite) accordingly.

5. This cleared up most of my HTML into Markdown and everything was beautiful. 
But one or two files might have extra flowing garbage text which you have to remove by yourself. Like the ones shown below. Clean them up manually.
![Blogger garbage text](https://i.imgur.com/l7m1fdB.png)

6. It's done.
It was painful but a lot of tools helped you do hours of work with a few keystrokes. Thank them.