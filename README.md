<p align="center">
<a href="https://travis-ci.org/dylanshine/TableViewLiaison">
<img src="https://travis-ci.org/dylanshine/TableViewLiaison.svg?branch=master&style=flat"
alt="Build Status">
</a>
<a href="https://cocoapods.org/pods/TableViewLiaison">
<img src="https://img.shields.io/cocoapods/v/TableViewLiaison.svg?style=flat"
alt="Pods Version">
</a>
</p>

----------------

`UITableView` made simple &#128588;

|         | Main Features  |
----------|-----------------
&#128585; | Skip the `UITableViewDataSource` & `UITableViewDelegate` boilerplate and get right to building your `UITableView`!
&#127744; | Closure based API for section and row configuration
&#128196; | Built-in paging functionality
&#9989;   | Unit Tested
&#128036; | Written in Swift 5.0

`TableViewLiaison` is 🔨 with &#10084;&#65039; by [📱 @ Shine Labs](https://www.shinelabs.dev).

## Requirements

- Xcode 10.2+
- iOS 10.0+

## Installation

### CocoaPods

The preferred installation method is with [CocoaPods](https://cocoapods.org). Add the following to your `Podfile`:

```ruby
pod 'TableViewLiaison'
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Usage
`TableViewLiaison` allows you to more easily populate and manipulate `UITableView` rows and sections.

### Getting Started
To get started, all you need to do is `liaise` an instance of `UITableView` to with a `TableViewLiaison`:

```swift
let liaison = TableViewLiaison()
let tableView = UITableView()

liaison.liaise(tableView: tableView)
```

By liaising your `UITableView` with the `TableViewLiaison`, the `TableViewLiaison` becomes its `UITableViewDataSource`, `UITableViewDelegate`, and `UITableViewDataSourcePrefetching`.
In the event you would like to remove the `UITableView` from the `TableViewLiaison`, simply invoke `liaison.detach()`.

`TableViewLiaison` implements a bunch of helper methods to help you manage your `UITableView`.

`TableViewLiaison` populates sections and rows using two main types:

### Section
`struct TableViewSection`

To create a section for our `UITableView`, create an instance of `TableViewSection` and add it to the `TableViewLiaison`.

```swift
let one = TableViewSection()
let two = TableViewSection(id: "ID")


let liaison = TableViewLiaison(sections: [one, two])
```
or

```swift
let section = TableViewSection()

liaison.append(section: section)
```

### Supplementary Section Views
To notify the `TableViewLiaison` that your `TableViewSection` will display a header and/or footer view, you must provide an instance of `TableViewSectionComponentDisplayOption` during initialization.

`TableViewSectionComponentDisplayOption` is an enumeration that notfies the liaison which supplementary views should be displayed for a given section. A header/footer view is represented by:

`class TableViewSectionComponent<View: UITableViewHeaderFooterView>`

```swift
let header = TableViewSectionComponent<UITableViewHeaderFooterView>()
let section = TableViewSection(option: .header(component: header))
```

You can set a static height of a `TableViewSectionComponent` by using either a CGFloat value or closure:

```swift
header.set(.height, 55)

header.set(.height) {
	// Some arbitrary user you pass into the closure...
    return user.username == "dylan" ? 100 : 75
}

header.set(.estimatedHeight, 125)
```

In the event a height is not provided for a `TableViewSectionComponent`, the `TableViewLiaison` will assume the supplementary view is self sizing and return a `.height` of `UITableView.automaticDimension`. Make sure you provide an `.estimatedHeight` to avoid layout complications.

The `TableViewSectionComponent ` views can be customized using `func set(_ command: TableViewSectionComponentCommand, with closure: @escaping (View, Int) -> Void)` at all the following lifecycle events:

- configuration
- didEndDisplaying
- willDisplay

```swift
header.set(.configuration) { view, section in
    view.textLabel?.text = "Section \(section)"
}

header.set(.willDisplay) { view, section in
    print("Header: \(view) will display for Section: \(section)")
}
```

### Rows
`class TableViewRow<Cell: UITableViewCell, Data>`

To add a row for a section, create an instance of `TableViewRow` and pass it to the initializer for a `TableViewSection` or if the row is added after instantiation you can perform that action via the `TableViewLiaison`:

```swift
let row = TableViewRow<RowTableViewCell, Int>(data: 1)
let statelessRow = StatelessTableViewRow<RowTableViewCell>()
let section = TableViewSection(rows: [row, statelessRow])
liaison.append(section: section)
```
or

```swift
let row = TableViewRow()
let section = TableViewSection()
liaison.append(section: section)
liaison.append(row: row)
```

`TableViewRow` heights are similarly configured to `TableViewSection`:

```swift
row.set(.height, 300)

row.set(.estimatedHeight, 210)

row.set(.height) {
	// Some arbitrary model you pass into the closure...
	switch model.type {
	case .large:
		return 400
	case .medium:
		return 200
	case .small:
		return 50
	}
}
```

In the event a height is not provided, the `TableViewLiaison` will assume the cell is self sizing and return `UITableView.automaticDimension`.

The `TableViewRow` can be customized using `func set(_ command: TableViewRowCommand, with closure: @escaping (TableViewLiaison, Cell, Data, IndexPath) -> Void) ` at all the following lifecycle events:

-  accessoryButtonTapped
-  configuration
-  delete
-  didDeselect
-  didEndDisplaying
-  didEndEditing
-  didHighlight
-  didSelect
-  didUnhighlight
-  insert
-  move
-  reload
-  willBeginEditing
-  willDeselect
-  willDisplay
-  willSelect

```swift
row.set(.configuration) { liaison, cell, data, indexPath in
	cell.label.text = "Cell: \(cell) at IndexPath: \(indexPath)"
	cell.label.font = .systemFont(ofSize: 13)
	cell.contentView.backgroundColor = .blue
	cell.selectionStyle = .none
}

row.set(.didSelect) { liaison, cell, data, indexPath in
	print("Cell: \(cell) selected at IndexPath: \(indexPath)")
}
```

`TableViewRow` can also utilize `UITableViewDataSourcePrefetching` by using `func set(prefetchCommand: TableViewPrefetchCommand, with closure: @escaping (IndexPath) -> Void)`

```swift
row.set(.prefetch) { cellViewModel, indexPath in
	cellViewModel.downloadImage()
}

row.set(.cancel) { cellViewModel, indexPath in
    cellViewModel.cancelImageDownload()
}
```

### Cell/View Registration
`TableViewLiaison` handles cell & view registration for `UITableView` view reuse on your behalf utilizing your sections/rows `TableViewRegistrationType<T>`.

`TableViewRegistrationType` tells the liaison whether your reusable view should be registered via a `Nib` or `Class`.

By default, `TableViewRow` is instantiated with `TableViewRegistrationType<Cell>.defaultClassType`.

`TableViewSection` supplementary view registration is encapsulated by its`TableViewSectionComponentDisplayOption`. By default, `TableViewSection` `option` is instantiated with `.none`.

### Pagination
`TableViewLiaison` comes equipped to handle your pagination needs. To configure the liaison for pagination, simply set its `paginationDelegate` to an instance of `TableViewLiaisonPaginationDelegate`.

`TableViewLiaisonPaginationDelegate` declares three methods:

`func isPaginationEnabled() -> Bool`, notifies the liaison if it should show the pagination spinner when the user scrolls past the last cell.

`func paginationStarted(indexPath: IndexPath)`, passes through the indexPath of the last `TableViewRow` managed by the liaison.

`func paginationEnded(indexPath: IndexPath)`, passes the indexPath of the first new `TableViewRow` appended by the liaison.

To update the liaisons results during pagination, simply use `append(sections: [AnyTableViewSection])` or `func append(rows: [AnyTableViewRow])` and the liaison will automatically handle the removal of the pagination spinner.

To use a custom pagination spinner, you can pass an instance `AnyTableViewRow` during the initialization of your `TableViewLiaison`. By default it uses `PaginationTableViewRow` provided by the framework.

### Tips & Tricks

Because `TableViewSection` and `TableViewRow` utilize generic types and manage view/cell type registration, instantiating multiple different configurations of sections and rows can get verbose. Leverage type aliases and/or implement a factory to create your various `TableViewRow`/`TableViewSectionComponent` types may be useful.

```swift

public typealias ImageRow= TableViewRow<ImageTableViewCell, UIImage>

static func imageRow(with image: UIImage) -> AnyTableViewRow {
	let row = ImageRow(data: image)

	row.set(.height, 225)

	row.set(.configuration) { liaison, cell, image, indexPath in
		cell.contentImageView.image = image
		cell.contentImageView.contentMode = .scaleAspectFill
	}

	return row
}
```

## Contribution

`TableViewLiaison` is a framework in its infancy. It's implementation is not perfect. Not all `UITableView` functionality has been `liaised` just yet. If you would like to help bring `TableViewLiaison` to a better place, feel free to make a pull request.

## Authors

✌️ Dylan Shine, dylan@shinelabs.dev

## License

TableViewLiaison is available under the MIT license. See the LICENSE file for more info.