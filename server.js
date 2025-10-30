const express = require("express");
const { createServer } = require("http");
const WebSocket = require("ws");

const app = express();
const server = createServer(app);
const port = process.env.PORT || 10000;

app.get("/", (req, res) => res.send("Render WebSocket bridge running"));

const wss = new WebSocket.Server({ server, path: "/render" });

wss.on("connection", (ws, req) => {
  console.log("Client connected:", req.socket.remoteAddress);
  const backend = new WebSocket("ws://152.44.38.209:2098/render");

  ws.on("message", (msg) => backend.readyState === WebSocket.OPEN && backend.send(msg));
  backend.on("message", (msg) => ws.readyState === WebSocket.OPEN && ws.send(msg));

  ws.on("close", () => backend.close());
  backend.on("close", () => ws.close());
});

server.listen(port, () => console.log(`Listening on ${port}`));
