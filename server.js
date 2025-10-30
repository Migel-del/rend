import express from "express";
import { createServer } from "http";
import WebSocket, { WebSocketServer } from "ws";

const app = express();
const server = createServer(app);
const port = process.env.PORT || 10000;

// обычный HTTP ping
app.get("/", (req, res) => res.send("Render WebSocket bridge running"));

// создаём WS-сервер на /render
const wss = new WebSocketServer({ server, path: "/render" });

wss.on("connection", (ws, req) => {
  console.log("Client connected:", req.socket.remoteAddress);

  // создаём соединение с твоим VPS Xray (plain WS)
  const backend = new WebSocket("ws://152.44.38.209:2098/render");

  ws.on("message", (msg) => backend.readyState === WebSocket.OPEN && backend.send(msg));
  backend.on("message", (msg) => ws.readyState === WebSocket.OPEN && ws.send(msg));

  ws.on("close", () => backend.close());
  backend.on("close", () => ws.close());
});

server.listen(port, () => console.log(`Listening on ${port}`));
