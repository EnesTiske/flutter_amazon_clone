const mongoose = require('mongoose');
const ratingSchema = require("./rating");

const productSchema = mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    description: {
        type: String,
        required: true
    },
    images: [
        {
            type: String,
            required: true,
        }
    ],
    quantity: {
        type: Number,
        required: true
    },
    price: {
        type: Number,
        required: true
    },
    category: {
        type: String,
        required: true
    },
    rating: [ratingSchema]

});

const Product = mongoose.model('Product', productSchema);
module.exports = { Product, productSchema };
