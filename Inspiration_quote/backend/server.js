import express from 'express'
import dotenv from 'dotenv'
import Router from './routes/routes.js'
import { dbConfig } from './config/databaseConfig.js'
dotenv.config()
const app = express()
app.use(express.json())
dbConfig()

app.use('/api/v1', Router)

app.listen(process.env.PORT, () =>
  console.log(`Server is listening at http://192.168.41.64://${process.env.PORT}`),
)