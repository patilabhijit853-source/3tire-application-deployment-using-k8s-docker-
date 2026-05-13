const express = require("express");
const app = express();

app.use(express.json());

// Root route
app.get("/", (req, res) => {
    res.send("Backend is running successfully 🚀");
});

// API route
app.get("/api", (req, res) => {
    res.json({
        message: "API working fine",
        status: "success"
    });
});

const PORT = 5000;

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});