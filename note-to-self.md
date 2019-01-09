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