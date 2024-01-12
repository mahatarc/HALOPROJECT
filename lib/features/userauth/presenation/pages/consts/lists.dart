const categoriesList = ['Crops', 'Tools', 'Machineries', 'Books'];

const categoryImages = [
  'images/crops.png',
  'images/gardening.png',
  'images/machineries.jpg',
  'images/books.png',
];

var Crops_list = [
  {
    "name": "Axe",
    "picture": "images/crops.png",
    "old_price": 500,
    "price": 400,
  },
  {
    "name": "Sickle",
    "picture": "images/crops.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/crops.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/crops.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/crops.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/crops.png",
    "old_price": 300,
    "price": 250,
  },
];

var machineries_list = [
  {
    "name": "Axe",
    "picture": "images/machineries.jpg",
    "old_price": 500,
    "price": 400,
  },
  {
    "name": "Sickle",
    "picture": "images/machineries.jpg",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/machineries.jpg",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/machineries.jpg",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/machineries.jpg",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/machineries.jpg",
    "old_price": 300,
    "price": 250,
  },
];

var books_list = [
  {
    "name": "Axe",
    "picture": "images/books.png",
    "old_price": 500,
    "price": 400,
  },
  {
    "name": "Sickle",
    "picture": "images/books.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/books.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/books.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/books.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/books.png",
    "old_price": 300,
    "price": 250,
  },
];

var tools_list = [
  {
    "name": "Axe",
    "picture": "images/axe.png",
    "old_price": 500,
    "price": 400,
  },
  {
    "name": "Sickle",
    "picture": "images/axe.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/axe.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/axe.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/axe.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/axe.png",
    "old_price": 300,
    "price": 250,
  },
];

var product_list = [
  {
    "name": "Axe",
    "picture": "images/axe.png",
    "old_price": 500,
    "price": 400,
  },
  {
    "name": "Sickle",
    "picture": "images/sickle.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/sickle.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/sickle.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/sickle.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/sickle.png",
    "old_price": 300,
    "price": 250,
  },
];

/*const categoriesList = ['Crops', 'Tools', 'Machineries', 'Books'];

const categoryImages = [
  'images/crops.png',
  'images/gardening.png',
  'images/machineries.jpg',
  'images/books.png',
];

class ProductLists{
  var Crops_list = [
  {
    "name": "Axe",
    "picture": "images/crops.png",
    "old_price": 500,
    "price": 400,
  },
  {
    "name": "Sickle",
    "picture": "images/crops.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/crops.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/crops.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/crops.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/crops.png",
    "old_price": 300,
    "price": 250,
  },
];

var machineries_list = [
  {
    "name": "Axe",
    "picture": "images/machineries.jpg",
    "old_price": 500,
    "price": 400,
  },
  {
    "name": "Sickle",
    "picture": "images/machineries.jpg",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/machineries.jpg",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/machineries.jpg",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/machineries.jpg",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/machineries.jpg",
    "old_price": 300,
    "price": 250,
  },
];

var books_list = [
  {
    "name": "Axe",
    "picture": "images/books.png",
    "old_price": 500,
    "price": 400,
  },
  {
    "name": "Sickle",
    "picture": "images/books.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/books.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/books.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/books.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/books.png",
    "old_price": 300,
    "price": 250,
  },
];

var tools_list = [
  {
    "name": "Axe",
    "picture": "images/axe.png",
    "old_price": 500,
    "price": 400,
  },
  {
    "name": "Sickle",
    "picture": "images/axe.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/axe.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/axe.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/axe.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/axe.png",
    "old_price": 300,
    "price": 250,
  },
];

var product_list = [
  {
    "name": "Axe",
    "picture": "images/axe.png",
    "old_price": 500,
    "price": 400,
  },
  {
    "name": "Sickle",
    "picture": "images/sickle.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/sickle.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/sickle.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/sickle.png",
    "old_price": 300,
    "price": 250,
  },
  {
    "name": "Sickle",
    "picture": "images/sickle.png",
    "old_price": 300,
    "price": 250,
  },
];

}*/
