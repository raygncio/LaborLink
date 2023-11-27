List<Map<String, dynamic>> labors = [
  {"name": "Plumbing", "path": "assets/icons/plumbing.png"},
  {"name": "Carpentry", "path": "assets/icons/carpentry.png"},
  {"name": "Electrical", "path": "assets/icons/electrical.png"},
  {"name": "Painting", "path": "assets/icons/painting.png"},
  {"name": "Maintenance", "path": "assets/icons/maintenance.png"},
  {"name": "Welding", "path": "assets/icons/welding.png"},
  {"name": "Housekeeping", "path": "assets/icons/housekeeping.png"},
  {"name": "Roofing", "path": "assets/icons/roofing.png"},
  {"name": "Installation", "path": "assets/icons/installations.png"},
  {"name": "Pest Control", "path": "assets/icons/pest.png"},
];

String imgPlaceholder = "https://i.stack.imgur.com/y9DpT.jpg";

String imgUrl =
    "https://st4.depositphotos.com/9998432/24359/v/450/depositphotos_243599464-stock-illustration-person-gray-photo-placeholder-man.jpg";

List<Map<String, dynamic>> dummyClients = List.generate(
    10,
    (index) => {
          "img_url": imgUrl,
          "name": "Client Name",
          "area": "Makati City",
          "rating": index < 5 ? index + 1 : 4,
        });

List<Map<String, dynamic>> dummyFilteredHandyman = List.generate(
    10,
    (index) => {
          "img_url": imgUrl,
          "name": "Handyman Name",
          "service": "Plumbing",
          "area": "Makati City",
          "rating": index < 5 ? index + 1 : 4,
        });

List<Map<String, dynamic>> dummyReviews = List.generate(
    15,
    (index) => {
          "name": "Reviewer Name",
          "img_url": imgUrl,
          "rating": index < 5 ? index + 1 : 4,
          "review":
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
          "date": "Aug 28, 2023",
        });

List<String> dummyDropdownData =
    List.generate(10, (index) => "Temp Data $index");

const List<String> specializations = <String>[
  'Plumbing',
  'Carpentry',
  'Electrical',
  'Painting',
  'Maintenance',
  'Welding',
  'Housekeeping',
  'Roofing',
  'Installations',
  'Pest Control'
];

const List<String> timeOptions = <String>[
  '8:00 - 9:00 am',
  '9:00 - 10:00 am',
  '10:00 - 11:00 am',
  '11:00 - 12:00 pm',
  '12:00 - 1:00 pm',
  '1:00 - 2:00 pm',
  '2:00 - 3:00 pm',
  '3:00 - 4:00 pm',
  '4:00 - 5:00 pm',
  '5:00 - 6:00 pm',
  '6:00 - 7:00 pm',
  '7:00 - 8:00 pm',
];

String loremIpsumLong =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

List<String> proposalImg = [
  "assets/icons/faucet.png",
  "assets/icons/sink.png",
];

List<Map<String, dynamic>> dummyActiveRequest =
    List.generate(6, (index) => {"progress": index});
