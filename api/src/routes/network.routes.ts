import express, { Request, Response, Router } from 'express';
import controller from '../controller/networks.controller';

const router:Router = express.Router()

router
  .get('/', controller.getNetworksAndContainers)
  .post('/', controller.createNetwork, controller.getNetworksAndContainers)
  .delete('/',controller.deleteNetwork, controller.getNetworksAndContainers)

export default router;
