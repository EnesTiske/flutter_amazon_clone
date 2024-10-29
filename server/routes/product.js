const express = require("express");
const productRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");

// /api/products?category=electronics
// /api/amazon?theme=dark
productRouter.get("/api/products", auth, async (req, res) => {
  try {
    console.log(req.query.category);
    const products = await Product.find({ category: req.query.category });
    res.json(products);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


productRouter.get("/api/products/search/:name", auth, async (req, res) => {
  try {
    console.log(req.query.category);
    const products = await Product.find({
      name: { $regex: req.params.name, $options: "i" },
    });
    res.json(products);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

productRouter.post("/api/rate-product", auth, async (req, res) => {
  try {
    const { id, rating } = req.body;
    const product = await Product.findById(id);

    for (let i = 0; i < product.rating.length; i++) {
      if (product.rating[i].userId === req.user) {
        product.rating.splice(i, 1);
        break;
      }
    }
    
    const ratingSchema = {
      userId: req.user,
      rating,
    };

    product.rating.push(ratingSchema);
    await product.save();
    res.json(product);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

productRouter.get("/api/deal-of-day", auth, async (req, res) => {
  try {
    let products = await Product.find({});
    
    products = products.sort((a, b) => {
      let aSum = 0;
      let bSum = 0;

      a.rating.forEach((rating) => {
        aSum += rating.rating;
      });

      b.rating.forEach((rating) => {
        bSum += rating.rating;
      });

      return aSum < bSum ? 1 : -1;
    })

    res.json(products[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = productRouter;
