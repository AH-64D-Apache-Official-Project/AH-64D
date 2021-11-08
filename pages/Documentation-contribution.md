Here is reference information that may be useful to those who are working on the development project. It is quite all over the place, but may contain useful information.

## Markdown and wiki basics

* [About Github wikis](https://docs.github.com/en/github/building-a-strong-community/about-wikis) (This contains useful how-tos at the bottom of the document)
* [Mastering markdown](https://guides.github.com/features/mastering-markdown/)
* [How to add links / images](https://docs.github.com/en/github/building-a-strong-community/editing-wiki-content)

## Emojis

Here is a list of common emojis to be used to categorise information in other posts.

| Icon | Text | Use |
| :-: | :- | :- |
| :information_source: | `:information_source:` | Some tangential information that is related to the current topic, but not central to it. |
| :heavy_exclamation_mark: | `:heavy_exclamation_mark:` | Warning, whether it is a common mistake made or something that doesn't work correctly in the mod. |
| :construction: | `:construction:` | This feature is not fully implemented, or is currently under construction |

For situations like :information_source: or :heavy_exclamation_mark: then you can place them in a blockquote (start the line with a `>`) to add appropriate formatting

> :information_source: So it looks like this

[Here](https://www.webfx.com/tools/emoji-cheat-sheet/) is a list of all available emojis

## How to prepare MPD page for upload.

In order to display an apache straight on, you might need to edit your screenshot. This is possible using GIMP. In this, I will assume you have it installed.

1) Open up your screenshot from ARMA in GIMP.
2) Set up your guidelines
    1) Decide on your size of your picture, I generally go 1000x1000px.
    2) Go to *Image > Guides > New Guide* and add a vertical and horizontal guide to the size you want.
3) Run a transform to straighten the image
    1) Go to *Tools > Transform Tools > Handle Transform*.
    2) Left click in each corner of the MPD you want to export to add a handle.
    3) Line up each corner of the MPD roughly to the corners shown by the guides.
    4) Zoom in and line up each corner more accurately
    5) Click the "Transform" button in the bottom right.
4) (optional) Sharpen the image.
    1) Go to *Filters > Enhance > Sharpen (Unsharp mask)*
    2) Start with the following values (for an MPD that doesn't have a map background): [Radius: 3, Amount: 1, Threshold: 0]
    3) Use the "Preview" and the "Split view" options to check that it looks okay, and adjust as needed.
    4) Click the "Ok" button to finalise.
5) Crop the output
    1) Go to *Image > Canvas Size..*
    2) Enter the size of the image you made in your guides.  
    3) Click "Resize"
6) Export using *File > Export as*