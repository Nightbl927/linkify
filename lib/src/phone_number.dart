import 'package:linkify/linkify.dart';

// matches "any amount of text with a phone number"
final _phoneNumberRegex = RegExp(r'(.*?)((\+\d{1,3}( )?)?((\(\d{1,3}\))|\d{1,3})[- .]?\d{3,4}[- .]?\d{4})', caseSensitive: false, dotAll: true);
//final _phoneNumberRegex = RegExp(r'(.*?)(([+]?\d{0,4}( )?[- .]?)?((\(\d{1,4}\))|\d{1,4})[- .]?\d{3,4}[- .]?\d{4})', caseSensitive: false, dotAll: true);

class PhoneNumberLinkifier extends Linkifier {
  const PhoneNumberLinkifier();

  @override
  List<LinkifyElement> parse(elements, options) {
    final list = <LinkifyElement>[];
    elements.forEach((element) {
      if (element is TextElement) {
        var match = _phoneNumberRegex.firstMatch(element.text);

        if (match == null) {
          list.add(element);
        } else {
          // create the preceding TextElement
          if (match.group(1)?.isNotEmpty == true) {
            list.add(TextElement(""));
          }

          // create the PhoneNumberElement
          if (match.group(2)?.isNotEmpty == true) {
            var phoneNumberText = match.group(0)!;
            var phoneNumberURL = "tel:" + phoneNumberText;

            list.add(PhoneNumberElement(phoneNumberText, phoneNumberURL));
          }

          // create the following TextElement
          final text = element.text.replaceFirst(match.group(0)!, '');
          if (text.isNotEmpty) {
            list.addAll(parse([TextElement(text)], options));
          }
        }
      } else {
        list.add(element);
      }
    });

    return list;
  }
}

class PhoneNumberElement extends LinkableElement {
  PhoneNumberElement(String text, String url) : super(text, url);

  @override
  String toString() {
    return "LinkElement: '$url' ($text)";
  }

  @override
  bool operator ==(other) => equals(other);

  @override
  bool equals(other) => other is UrlElement && super.equals(other);
}
