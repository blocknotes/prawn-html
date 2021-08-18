# Prawn HTML
[![gem version](https://badge.fury.io/rb/prawn-html.svg)](https://rubygems.org/gems/prawn-html)
[![linters](https://github.com/blocknotes/prawn-html/actions/workflows/linters.yml/badge.svg)](https://github.com/blocknotes/prawn-html/actions/workflows/linters.yml)
[![specs](https://github.com/blocknotes/prawn-html/actions/workflows/specs.yml/badge.svg)](https://github.com/blocknotes/prawn-html/actions/workflows/specs.yml)

HTML to PDF renderer using [Prawn PDF](https://github.com/prawnpdf/prawn).

Features:
- support a [good set](#supported-tags--attributes) of HTML tags and CSS properties;
- handle [document styles](#document-styles);
- custom [data attributes](#data-attributes) for Prawn PDF features;
- no extra settings: it just parses an input HTML and outputs to a Prawn PDF document.

**Notice**: render HTML documents properly is not an easy task, this gem support only some HTML tags and a small set of CSS attributes. If you need more rendering accuracy take a look at other projects like WickedPDF.

> [prawn-styled-text](https://github.com/blocknotes/prawn-styled-text) rewritten from scratch, finally!

Please :star: if you like it.

## Install

- Add to your Gemfile: `gem 'prawn-html'` (and execute `bundle`)
- Just call `PrawnHtml.append_html` on a `Prawn::Document` instance (see the examples)

## Examples

```rb
require 'prawn-html'
pdf = Prawn::Document.new(page_size: 'A4')
PrawnHtml.append_html(pdf, '<h1 style="text-align: center">Just a test</h1>')
pdf.render_file('test.pdf')
```

To check some examples with the PDF output see [examples](examples/) folder.

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

- **background**: for *mark* tag (3/6 hex digits or RGB or color name), ex. `style="background: #FECD08"`
- **color**: (3/6 hex digits or RGB or color name) ex. `style="color: #FB1"`
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

For colors, the supported formats are:
- 3 hex digits, ex. `color: #FB1`;
- 6 hex digits, ex. `color: #abcdef`;
- RGB, ex. `color: RGB(64, 0, 128)`;
- color name, ex. `color: yellow`.

## Data attributes

Some custom data attributes are used to pass options:

- **dash**: for *hr* tag, accepts an integer or a list of integers), ex. `data-data="2, 4, 3"`
- **mode**: allow to specify the text mode (stroke|fill||fill_stroke), ex. `data-mode="stroke"`

## Document styles

[Experimental feature] You can define document CSS rules inside an _head_ tag, but with a limited support for now.
Only single CSS selectors and basic ones are supported. Example:

```html
<!DOCTYPE html>
<html>
<head>
  <title>A test</title>
  <style>
    body { color: #abbccc }
    .green {
      color: #0f0;
      font-family: Courier;
    }
    #test-1 { font-weight: bold }
  </style>
</head>
<body>
  <div class="green">
    Div content
    <span id="test-1">Span content</span>
  </div>
</body>
</html>
```

## Do you like it? Star it!

If you use this component just star it. A developer is more motivated to improve a project when there is some interest.

Or consider offering me a coffee, it's a small thing but it is greatly appreciated: [about me](https://www.blocknot.es/about-me).

## Contributors

- [Mattia Roccoberton](https://www.blocknot.es): author

## License

The gem is available as open-source under the terms of the [MIT](LICENSE.txt).
