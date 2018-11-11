---
title: "Theme Accessibility - Part 1"
date: 2018-11-09T15:11:44-05:00
draft: true
---

*Deleted a bunch of things here due to rambling. I'm not an experience writer and really need to get myself better at hitting the point.*  
The current theme I'm using is [Bilberry-hugo-theme](https://github.com/Lednerb/bilberry-hugo-theme). This post will only focus on color contrasts issue for a few reasons:
- It can be visually perceived  
- It is one of the area that automated checker are better at.  
- Small area of focus so that I have room for tips and takeaway.  
<!--more-->

### Get started with a quick check

I ran a quick Accessibility Test with [WAVE Accessibility Checker](https://wave.webaim.org/)(it comes as a convenient browser extension for Chrome Browser). You can also use their Saas base webtool or Firefox extension. 

The first count was 26 color contrast errors that include:  
- The date, catagories, author fields right under each post's title  
- The social icons  
- The link to "Continue reading"  
- THe footer text  

Thanks to the power of Hugo Pipeline, it only took changing a few scss variables to remedy most of the errors.
All I needed was updating **_variables.scss** with the following:
```
$meta-text-color: #262626;
$highlight-color: #344e32;
```
And **_footer.scss** inside **.credits** class with:
```
color: #293e28;
```

After these changes, the color contrasts on the page start looking pretty good.
However, another audit from WAVE still shows 4 color contrast errors pointing towards the social icons
![Color contrast errors highlighted on the social icons](link to the image)

Hmm, it looks pretty good to me.
So I ran the aXe extension from Chrome Browser, the result was as I expected: no color contrasts errors.  
Inconclusive, guess I'll have to check it myself. A quick inspection using Chrome DevTools, I confirmed that the social icons have color contrast index of 8.62:1 on the white background. We are all good to go. 

Write something about not to trust the automated tools...


Hover on Phuc Duong's Blog
Color changes and does not meet color contrast
Is it required at all the profile icon and link both goes to the same place.
There is also a nav bar after I created the About Me page.
Simplify? YES

1. Add the link on Navbar to the main blog page
With bilberry theme, it is as easy as:
```hugo new page/blog.md"```
and add the content:
```
---
title: "Blog"
date: ...
draft: ...
excludeFromTopNav: false

# set the link if you want to redirect the user.
link: "/"
---
```

Now that I have that on the nav bar, I can remove the links from the profile icon and the blog heading.
This is done within `themefolder/layouts/partials/header.html`