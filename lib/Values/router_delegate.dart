// void parseRoute(Uri uri) {
// // 1
//   if (uri.pathSegments.isEmpty) {
//     setNewRoutePath(SplashPageConfig);
//     return;
//   }

// // 2
//   // Handle navapp://deeplinks/details/#
//   if (uri.pathSegments.length == 2) {
//     if (uri.pathSegments[0] == 'details') {
// // 3
//       pushWidget(Details(int.parse(uri.pathSegments[1])), DetailsPageConfig);
//     }
//   } else if (uri.pathSegments.length == 1) {
//     final path = uri.pathSegments[0];
// // 4
//     switch (path) {
//       case 'splash':
//         replaceAll(SplashPageConfig);
//         break;
//       case 'login':
//         replaceAll(LoginPageConfig);
//         break;
//       case 'createAccount':
// // 5
//         setPath([
//           _createPage(Login(), LoginPageConfig),
//           _createPage(CreateAccount(), CreateAccountPageConfig)
//         ]);
//         break;
//       case 'listItems':
//         replaceAll(ListItemsPageConfig);
//         break;
//       case 'cart':
//         setPath([
//           _createPage(ListItems(), ListItemsPageConfig),
//           _createPage(Cart(), CartPageConfig)
//         ]);
//         break;
//       case 'checkout':
//         setPath([
//           _createPage(ListItems(), ListItemsPageConfig),
//           _createPage(Checkout(), CheckoutPageConfig)
//         ]);
//         break;
//       case 'settings':
//         setPath([
//           _createPage(ListItems(), ListItemsPageConfig),
//           _createPage(Settings(), SettingsPageConfig)
//         ]);
//         break;
//     }
//   }
// }
