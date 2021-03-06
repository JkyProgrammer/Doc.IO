# A Test Document (ish)

## Requirements

This is a sample for the **MarkDown Viewer** to render. The *renderer* should be:
The only downside is that one can only have *italics* and __bolds__ in ordinary paragraphs. For now this *should* be okay.

* Fast and efficient
* Non-intrusive
* Nice looking
* Simple to use

## Theory

So here's how it works basically.
* Firstly, we search through the document, looking for special characters.
* Then we generate a map from those, denoting fonts to be used for specific strings
* Then we process the map, and turn it into a set of attributed strings
* And put those attributed strings into the text view.

## Specials
 
* **bold** or __bold__
* *italic* or _italic_
* Unordered
_ Lists
# Heading Level 1
## Headings Level 2
and
### Headings Level 3
We can have code snippets using backticks:
`public static void main (String[] args) {
	for (int i = 0; i < 10; i++) {
		System.out.println ("Hello, World!");
	}
}`
And they can be inline, like this. `if (goingToCrashIntoEachOther ()) { dont(); }`
And we can always tell someone we've got something wrong. ~~Like now~~
We can have links, for example, to an image.
[A link to an image](/Users/javaxprogrammer/Pictures/hovr.png)
[A link to a file](file:///Users/javaxprogrammer/Documents/GitHub/Quantum/TestClass.java)
[A web link](https://github.com/JkyProgrammer/Quantum)
[An ftp link](ftp://localhost)
[A ssh link](ssh://localhost)
In short, you can have literally any kind of link.