const mongoose = require("mongoose");
const { productSchema } = require("./product");

const orderSchema = new mongoose.Schema({
  products: [
    {
      product: productSchema,
      quantity: {
        type: Number,
        required: true,
      },
    },
  ],
  totalPrice: {
    type: Number,
    required: true,
  },
  address: {
    type: String,
    required: true,
  },
  userId: {
    type: String,  
    required: true,
  },
  orderedAt: {
    type: Date,
    default: Date.now,
  },
  status: {
    type: String,
    default: 0,
  },
});

const Order = mongoose.model("Order", orderSchema);
module.exports = Order;
