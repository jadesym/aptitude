import { Router } from "express";

const statusRouter = Router();

statusRouter.get("/", (_req, res) => {
  res.json({
    isServerAvailable: true,
  });
});

export default statusRouter;
