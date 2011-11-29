# Transit

Transit is a content delivery engine for Rails using MongoDB. Content delivery engine is not just a fancy word but more clearly defines the purpose 
that the gem aims to solve. Most Rails based CMS solutions are "ready to go" applications, where a few simple configurations will get you up and running with 
a full (often well designed) admin interface and all.

The goal of Transit is to be more developer-oriented, for use in situations where you still want to develop custom content managed applications, but avoid 
having to do a lot of the same routine development thats common to most if not all content management systems.

Transit operates around the concept that all content management can be broken down into two types of models (called deliverables): a Post or a Page. 

Each *deliverable*  can embed one or many `contexts` which are representations of a particular type of content included within that piece of deliverable content.

### Posts

Posts are your standard blog/article/etc posts, which consist of a 
* title
* post date
* published/un-published status
* a *body* which defines the content that post contains.
* a *teaser* which is used as a "preview" of the post.
* a slug which represents the url to the post. On creation, this field is automatically created from the title unless already provided.

### Pages

Pages are the "standalone" version of a post. Whereas posts operate on a feed type system, pages are singular in nature and consist of
* a url (ie: slug).
* a name (whether internal or for use in a heading tag)
* a page title
* optional keywords
* a page description
* one or more *body* areas depending on the layout of the particular page.

Content
-------

Deliverables associate (ie: embed) one or more `contexts` which, when combined, represent the content a particular package contains. Each context is assigned 
any number of attributes, and a `position` which defines the order in which that context exists in the flow of content.

Instead of cramming content into some wysiwyg editor (which is generally good for nothing except butchering a well-designed layout), 
multiple contexts can be created and chained together, limiting html/rich-text editing to basic formatting.

**Delivery**

Content is delivered by using the `deliver` method in your views, passing a particular deliverable containing contexts.

	<%= deliver(@post) %>
	
By default the helper will attempt to deliver content in one of 2 ways:

1. If a `deliver` method exists on a context model, the result of that method will be output
2. Using a pre-defined delivery block that, when passed a context and template object builds the necessary html to render that context. For example, to deliver an `Audio`
   context using Rails' built in audio tag helper:

	Transit::Delivery.configure(:audio) do |context, template|
		template.audio_tag(context.source)
	end
	
Contexts
-------

There are 3 contexts included in the core engine:

1. **TextBlock**: Used to represent body copy / content. This is usually managed with a wysiwyg editor
2. **Video**: Allows inserting video from multiple sources, whether file upload, youtube url, etc.
3. **Audio**: Same function as video... but included separately to allow for more customization.

### Creating Custom Contexts

To create a custom context, simply create a model that subclasses the Context model. 

Additional Items
-------

### Content Blocks

Content blocks are similar to pages, but are simply wrappers for storing/delivering a set of contexts. Content blocks are useful for things like 
sidebars or areas of content that are used in multiple places within the site, providing a single point of access and management in your back-ends.

### Assets

To provide support for file and image uploads, an Asset model is provided. This model can accept any type of file upload, stored as the `file` field. 
The asset model also provides methods to determine whether a file is an `image?`, `video?`, or `audio?`. 

License
-------

Copyright (c) 2010, 2011 Brent Kirby / kurb media llc

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


