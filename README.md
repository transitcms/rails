Transit
==========================

![Build Status](https://secure.travis-ci.org/transitcms/engine.png?branch=master&.png)

Transit is a content delivery engine for Rails using MongoDB. Content delivery engine is not just a fancy word but more clearly defines the purpose 
that the gem aims to solve. Most Rails based CMS solutions are "ready to go" applications, where a few simple configurations will get you up and running with 
a full (often well designed) admin interface and all.

The goal of Transit is to be more developer-oriented, for use in situations where you still want to develop custom content managed applications, but avoid 
having to do a lot of the same routine development thats common to most if not all content management systems.

Transit operates around the concept that all content management can be broken down into two basic types of models (called deliverables): a Post or a Page. 

Each *deliverable*  can embed one or many `contexts` which are representations of a particular type of content included within that deliverable.


Posts
--------------------------

Posts are your standard blog/article/etc posts, which consist of a 
* title
* post date
* published/un-published status
* a *body* which defines the content that post contains.
* a *teaser* which is used as a "preview" of the post.
* a slug which represents the url to the post. On creation, this field is automatically created from the title unless already provided.


Pages
--------------------------

Pages are the "standalone" version of a post. Whereas posts operate on a feed type system, pages are singular in nature and consist of
* a url (ie: slug).
* a name (whether internal or for use in a heading tag)
* a page title
* optional keywords
* a page description
* one or more *body* areas depending on the layout of the particular page.


Content
--------------------------

Deliverables associate (ie: embed) one or more `contexts` which, when combined, represent the content a particular package contains. Each context is assigned 
any number of attributes, and a `position` which defines the order in which that context exists in the flow of content.

Instead of cramming content into some wysiwyg editor (which is generally good for nothing except butchering a well-designed layout), 
multiple contexts can be created and chained together, limiting html/rich-text editing to basic formatting.

For instance, a basic blog post can be broken down into a primary heading, and some body content. In terms of contexts, this can be broken down into a 
`InlineText` and `TextBlock`. When creating your custom Blog cms, you could then specify that each time a new post is created, it should initially contain 
these two contexts, as well as the order (ie: InlineText > TextBlock). When users create new content, they then have these two fields available to them. 

The true benefit of contexts is in the output. Given the example above, you now have a way to cleanly output a blog post, with a proper heading (ie: h1) 
and well formatted body copy. Output is left to the discretion of the developer, not the end-user.

Should you want to provide additional functionality, any number of contexts can be added to a deliverable. Your users want to add video or audio to 
their blog posts? No problem. In addition, since each context contains a `position` property, by simply sorting/and arranging each context, the 
resulting output can be altered to whatever desired result.

**Delivery**

Content is delivered by using the `deliver` method in your views, passing a particular deliverable containing contexts.

	<%= deliver(@post) %>
	

1. If a `deliver` method exists on a context model, the result of that method will be output, unless that method explicitly returns `false`
2. Rendering a partial found under `app/views/transit/contexts/_context_class.html.erb`.

Contexts
--------------------------

There are 4 basic contexts included in the core engine:

1. **InlineText**: Text that is best represented by a single html node, such as a heading (h1, h2, h3, etc).
2. **TextBlock**: Used to represent body copy / content. This is usually managed with a wysiwyg editor
3. **Video**: Allows inserting video from multiple sources, whether file upload, youtube url, etc.
4. **Audio**: Same function as video... but included separately to allow for more customization.

### Creating Custom Contexts

To create a custom context, simply create a model that subclasses the Context model. 


Additional Items
--------------------------

### Content Blocks

Content blocks are similar to pages, but are simply wrappers for storing/delivering a set of contexts. Content blocks are useful for things like 
sidebars or areas of content that are used in multiple places within the site, providing a single point of access and management in your back-ends.

### Assets

To provide support for file and image uploads, an Asset model is provided. This model can accept any type of file upload, stored as the `file` field. 
The asset model also provides methods to determine whether a file is an `image?`, `video?`, or `audio?`. 


License
--------------------------

Copyright (c) 2010, 2011 Brent Kirby / kurb media llc

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


