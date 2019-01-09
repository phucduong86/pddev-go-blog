---
title: "Theme Accessibility - Quick check"
date: 2018-11-09T15:11:44-05:00
draft: false

categories: ["accessibility"]
tags: ["Hugo", "Bilberry theme", "automated accessibility testing", "accessibility", "audit"]
author: "Phuc Duong"
---

Some quick audit on color contrasts.

The current theme I'm using is [Bilberry-hugo-theme](https://github.com/Lednerb/bilberry-hugo-theme). This post will only focus on color contrasts issue for a few reasons:
- It can be visually perceived  
- It is one of the area that automated checker are better at.  
- Small area of focus so that I have room for tips and takeaway.  

### Get started with a quick check

I ran a quick Accessibility Test with [WAVE Accessibility Checker](https://wave.webaim.org/)(it comes as a convenient browser extension for Chrome Browser). You can also use their Saas base webtool or Firefox extension. 

The first count was 26 color contrast errors that include:  
- The date, catagories, author fields right under each post's title  
- The social icons  
- The link to "Continue reading"  
- The footer text  

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
However, another audit from WAVE still shows 4 color contrast errors pointing towards the social icons so I ran the aXe extension from Chrome Browser. The result was as I expected: no color contrasts errors.  

After quick inspection using Chrome DevTools, we can get the value of the background and foreground colors.
The color contrast checker tool from [WebAIM](https://webaim.org/resources/contrastchecker/) confirmed that the social icons have color contrast index of 8.62:1 on the white background. We are all good to go. 

Take away: automated tools are great but they won't address all the issues on your websites at the most, and there will be false positives as well. Trust yourself when it is an usability issue because if it seems to be an issue for you, it might be an issue for another person too.