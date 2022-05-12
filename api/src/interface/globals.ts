declare global {
    namespace NodeJS {
      export interface ProcessEnv {
        API_PORT: string;
        API_KEY:string;
        API_SECRET:string
      }
    }
  }

declare global {
  namespace Express {
    interface Request {
      user:any
    }
  }
}

export {}