import dotenv from 'dotenv';
dotenv.config();

const origins = [
            `http://localhost:4000`,
          ]

const routes = [
  '/xumm/ping',
]

const constants = {
    routes, 
    origins
}

export default constants
