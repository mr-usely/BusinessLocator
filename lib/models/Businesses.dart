class Businesses {
  String id, name, address, barangay, classification;
  double lat, lng;
  bool isSelected = false;
  bool isOnDelete = false;

  Businesses(
      {required this.id,
      required this.name,
      required this.address,
      required this.barangay,
      required this.lat,
      required this.lng,
      required this.classification});
}

// test list
List<Businesses> itemList = [
  Businesses(
      id: "637baf2cc707e2dd691d64c0",
      name: "2J'S BARBER SHOP",
      address: "DISTRICT 1, CAUAYAN CITY, ISABELA",
      barangay: "District 1",
      lat: 16.93509771452136,
      lng: 121.77358595462289,
      classification: "Small"),
  Businesses(
      id: "637baf2cc707e2dd691d64c1",
      name: "MAMA'S LITTLE CHEF PANSITERIA",
      address: "DISTRICT 1, CAUAYAN CITY, ISABELA",
      barangay: "District 1",
      lat: 16.933658655873568,
      lng: 121.77421301486137,
      classification: "Small"),
  Businesses(
      id: "637baf2cc707e2dd691d64c02",
      name: "ISABELA CAR RENTAL",
      address: "42, Purok 4 Turayong Rd, Cauayan City, 3305 Isabela",
      barangay: "Turayong",
      lat: 16.942927153380822,
      lng: 121.77502452166344,
      classification: "Medium"),
  Businesses(
      id: "637baf2cc707e2dd691d64c3",
      name: "NATHANIEL'S NATURE DROPS WATER REFILLING STATION",
      address: "TAGARAN, CAUAYAN CITY, ISABELA",
      barangay: "Tagaran",
      lat: 16.96502997100683,
      lng: 121.7780490411296,
      classification: "Medium"),
  Businesses(
      id: "637baf2cc707e2dd691d64c4",
      name: "MCL FURNITURE SHOP",
      address: "DISTRICT 2, CAUAYAN CITY, ISABELA",
      barangay: "District 2",
      lat: 16.94064667321315,
      lng: 121.76816770032818,
      classification: "Small"),
  Businesses(
      id: "637baf2cc707e2dd691d64c5",
      name: "OVEN HOUSE CAKES AND PASTRIES",
      address:
          "District 1, Phase 2, Christine Village, Cauayan City, 3305 Isabela",
      barangay: "District 1",
      lat: 16.923022068119256,
      lng: 121.7696410967947,
      classification: "Medium"),
  Businesses(
      id: "637baf2cc707e2dd691d64c6",
      name: "BHING BHONG BALOT STORE",
      address: "SAN FERMIN, CAUAYAN CITY, ISABELA",
      barangay: "San Fermin",
      lat: 16.93653477615791,
      lng: 121.76149989695215,
      classification: "Small"),
  Businesses(
      id: "637baf2cc707e2dd691d64c7",
      name: "GINA'S EATERY",
      address: "DISTRICT 1, CAUAYAN CITY, ISABELA",
      barangay: "District 1",
      lat: 16.949268699820916,
      lng: 121.77678949263465,
      classification: "Medium"),
  Businesses(
      id: "637baf2cc707e2dd691d64c8",
      name: "ABOVE CAFETEA AND RESTAURANT",
      address: "DISTRICT 1, CAUAYAN CITY, ISABELA",
      barangay: "District 1",
      lat: 16.933773121641,
      lng: 121.7718867114726,
      classification: "Small"),
  Businesses(
      id: "637baf2cc707e2dd691d64c9",
      name: "KAWAYAN FOOD PRODUCTS",
      address: "SAN FERMIN, CAUAYAN CITY, ISABELA",
      barangay: "San Fermin",
      lat: 16.995876445453302,
      lng: 121.7939292292389,
      classification: "Medium")
];
