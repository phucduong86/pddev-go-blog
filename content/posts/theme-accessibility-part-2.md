---
title: "Bilberry Hugo Theme Accessibility Part 2"
date: 2019-01-22T00:08:06-05:00
draft: false

categories: ["accessibility"]
tags: ["Hugo", "Bilberry theme", "automated accessibility testing", "accessibility", "audit"]
author: "Phuc Duong"
---

Quick work on links to article with [Bilberry-hugo-theme](https://github.com/Lednerb/bilberry-hugo-theme).  
Improve on accessibility by removing redundant links to the same location.  

<!--more-->

Now that I've removed the link to "Phuc Duong's Blog" header. User can get to my the main content in 4 Tabs (I do intend on eventually have a Skip to Main shortcut when the site grows, it is quite acceptable for a small hobby site at the moment.)

From here, unfortunately user will have to tab 3 times to get to my next article in the list. In fact, with the links to categories and tags, 3 would be the minimum amount of tabs. I'm hoping to make remove 2 of the links and the 3rd one seems to be the best option to keep (with some little tweaks).

Since the link bubble is gone, there is no reason to keep the bubble itself either. Now I can trim down the whole left side of the page, and expand the main content to full page width. I believe the bubbles were there to differentiate the different type of contents (article, music, galerry...). So I'll have to come up with a more universal alternative later.
