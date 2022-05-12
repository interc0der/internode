import express, { Request, Response, Router } from 'express';
import controller from '../controller/containers.controller';

const router:Router = express.Router()

router
    .get('/',controller.getRunningContainers)
    .delete('/', controller.disconnectContainer)
    .put('/', controller.connectContainer)

export default router;
