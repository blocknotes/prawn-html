# Prawn HTML
[![linters](https://github.com/blocknotes/prawn-html/actions/workflows/linters.yml/badge.svg)](https://github.com/blocknotes/prawn-html/actions/workflows/linters.yml)
[![specs](https://github.com/blocknotes/prawn-html/actions/workflows/specs.yml/badge.svg)](https://github.com/blocknotes/prawn-html/actions/workflows/specs.yml)

HTML to PDF renderer using [Prawn PDF](https://github.com/prawnpdf/prawn).

> Still in beta. [prawn-styled-text](https://github.com/blocknotes/prawn-styled-text) rewritten from scratch

**Notice**: render HTML documents properly is not an easy task, this gem support only some HTML tags and a small set of CSS attributes. If you need more rendering accuracy take a look at other projects like WickedPDF.

Please :star: if you like it.

## Install

- Add to your Gemfile: `gem 'prawn-html', git: 'https://github.com/blocknotes/prawn-html.git'` (and execute `bundle`)
- Use the class `HtmlHandler` on a `Prawn::Document` instance

## Examples

```rb
require 'prawn-html'
pdf = Prawn::Document.new(page_size: 'A4')
PrawnHtml::HtmlHandler.new(pdf).process('<h1 style="text-align: center">Just a test</h1>')
pdf.render_file('test.pdf')
```

## Supported tags & attributes

HTML tags:

- **a**: link
- **b**: bold
- **br**: new line
- **del**: strike-through
- **div**: block element
- **em**: italic
- **h1** - **h6**: headings
- **hr**: horizontal line
- **i**: italic
- **ins**: underline
- **img**: image
- **li**: list item
- **mark**: highlight
- **p**: block element
- **s**: strike-through
- **small**: smaller text
- **span**: inline element
- **strong**: bold
- **u**: underline
- **ul**: list

CSS attributes (dimensional units are ignored and considered in pixel):

- **background**: for *mark* tag, only 3 or 6 hex digits format, ex. `style="background: #FECD08"`
- **color**: only 3 or 6 hex digits format - ex. `style="color: #FB1"`
- **font-family**: font must be registered, quotes are optional, ex. `style="font-family: Courier"`
- **font-size**: ex. `style="font-size: 20px"`
- **font-style**: values: *:italic*, ex. `style="font-style: italic"`
- **font-weight**: values: *:bold*, ex. `style="font-weight: bold"`
- **height**: for *img* tag, ex. `<img src="image.jpg" style="height: 200px"/>`
- **href**: for *a* tag, ex. `<a href="http://www.google.com/">Google</a>`
- **letter-spacing**: ex. `style="letter-spacing: 1.5"`
- **line-height**: ex. `style="line-height: 10px"`
- **margin-bottom**: ex. `style="margin-bottom: 10px"`
- **margin-left**: ex. `style="margin-left: 15px"`
- **margin-top**: ex. `style="margin-top: 20px"`
- **src**: for *img* tag, ex. `<img src="image.jpg"/>`
- **text-align**: `left` | `center` | `right` | `justify`, ex. `style="text-align: center"`
- **text-decoration**: `underline`, ex. `style="text-decoration: underline"`
- **width**: for *img* tag, support also percentage, ex. `<img src="image.jpg" style="width: 50%; height: 200px"/>`

## Do you like it? Star it!

If you use this component just star it. A developer is more motivated to improve a project when there is some interest.

Or consider offering me a coffee, it's a small thing but it is greatly appreciated: [about me](https://www.blocknot.es/about-me).

## Contributors

- [Mattia Roccoberton](https://www.blocknot.es): author

## License

The gem is available as open-source under the terms of the [MIT](LICENSE.txt).
