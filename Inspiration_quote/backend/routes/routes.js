import express from 'express'
import { getUser } from '../middlewares/getuser.js'
import {
  getAllUsers,
  getSingleUser,
  signUp,
  login,
  updateProfile,
  deleteProfile,
} from '../controllers/authentication.js'

import { authMiddleWare } from '../middlewares/authmiddleware.js'
import dotenv from 'dotenv'
import {
  addToMyFavorites,
  createQuote,
  deleteQuote,
  getAllQuotes,
  getFavorites,
  getQuote,
  removeFromMyFavorites,
  updateQuote,
} from '../controllers/quote.js'
dotenv.config()
const router = express.Router()
router.get("/test",(req,res)=>{
  return res.status(200).send({employees:[
    {
      "id":1,
      "email":"michael.lawson@demo.io",
      "firstName":"Michael",
      "lastName":"Lawson"
    },
    {
      "id":2,
      "email":"dave@gmail.io",
      "firstName":"Dawit",
      "lastName":"T"
    },
    {
      "id":3,
      "email":"alayu@gmai.com",
      "firstName":"Alayu",
      "lastName":"E"
    }
  ]})
})
router.get('/getallusers', [authMiddleWare], getAllUsers)
router.get('/getuser/:id', [authMiddleWare, getUser], getSingleUser)
router.post('/signup', signUp)
router.post('/login', login)
router.put('/updateprofile/:id', [getUser, authMiddleWare], updateProfile)
router.delete('/deleteprofile/:id', [authMiddleWare, getUser], deleteProfile)

/////////////////////////
//for only authenticated users
router.get('/quote', [authMiddleWare], getAllQuotes)
router.get('/quote/:id', [authMiddleWare], getQuote)
router.get('/quote/favorite/:id',[authMiddleWare,getUser],getFavorites)
router.post('/quote', [authMiddleWare], createQuote)
router.post('/quote/favorite/:id', [authMiddleWare], addToMyFavorites),
router.put('/quote/:id', [authMiddleWare], updateQuote)
router.delete('/quote/:id', [authMiddleWare], deleteQuote)
router.delete('/quote/favorite/:id', [authMiddleWare], removeFromMyFavorites)
export default router
