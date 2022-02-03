# bookmark-formatter
Tool create for personal use to convert folders of yaml files to importable browser bookmarks. (Currently supports Firefox.)

### What does this do?
It takes a folder of yaml files and parses it to allow you to import everything as bookmarks to your browser (supports subfolders).

### Why?
Uh...I dunno.

### What's the format?
Each folder/subfolder (besides the root) must contain a `__meta.yaml` file (that's 2 underscores), with at the very least a `name` tag at the top level, assigned to a string. This allows you to name the folder whatever you want--the name of the folder when you import it will be `name`. Files (which must have the extension `.yaml`) must contain `name` and `url` tags. (In the future, more tag support will be added.) An example is in the `example` folder.

### How do you use it?
Although I will add an actual CLI in the future, for now you'd use `racket [path/to/testfile.rkt] [path/to/bookmarks/root] [path/to/format/file]`, without brackets. The format file, for now, is `ff-format.html`

### Can I create my own format files?
Yes! In order to do so, use the tag `<bm-fmt> / </bm-fmt>` to denote that start/end of where the bookmarks should go (you must include both). You also need `<fo-fmt> / </fo-fmt>` and `<fi-fmt> / </fi-fmt>` tags *both nested within* the bm-fmt element. Inside fo-fmt and fi-fmt (which stand for "folder format" and "file format", respectively), you can add placeholders using `$` like `$name` and `$url` to match tags in your yaml files. (See `ff-format.html` for an example.)

### Why is this in *Racket* of all languages?
Hey, I thought it'd be fun to try out some functional programming! I learned a little bit of Racket through a college class, and even though it would've been way easier to just hack it together with JavaScript, I thought I'd try something new for a change. Besides, I think it turned out way cleaner this way.

