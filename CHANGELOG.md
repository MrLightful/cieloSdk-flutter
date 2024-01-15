## 0.0.2

The release mostly meant to improve Pub scoring of the package.

- Longer project description
- Example project
- More dartdoc for public API
- Dart formatting

*Breaking change:* 
- Fix method signature: `Cielo.sop.sendCard(CieloCard card, {required String accessToken})`.

## 0.0.1

The first public release of the package.
It integrates the most basic features of Cielo.

#### Features
- SDK's core initialization with options (supports Cielo and Braspag, and sandbox and production environments)
- Client-side validation of card data (mod10, brand-based, etc.)
- Silent Order Post (SOP) integration: `Cielo.initSOP()` and `Cielo.sop.sendCard(card, accessToken=accessToken)`
- Profound testing of basic features

