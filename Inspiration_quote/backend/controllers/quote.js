import { BaseUserModel } from '../models/baseUser.js'
import QuoteModel from '../models/quote.js'
import mongoose from 'mongoose'
export const getAllQuotes = async (req, res) => {
  try {
    const quotes = await QuoteModel.find()
    return res.status(200).send({ quotes })
  } catch (e) {
    return res.status(501).send({ message: e.message })
  }
}
export const getQuote = async (req, res) => {
  const id = req.params.id
  try {
    const quote = await QuoteModel.findById(id)
    if (quote) {
      return res.status(200).send({ quote })
    } else {
      return res
        .status(404)
        .send({ message: `Quote with this id: ${id} was not found` })
    }
  } catch (e) {
    return res.status(501).send({ message: e.message })
  }
}
export const createQuote = async (req, res) => {
  const body = req.body
  try {
    const quote = await QuoteModel.create(body)
    const admin = await BaseUserModel.findOne({ role: 'admin' })
    console.log('Admin is ', admin)
    if (!admin) return res.status(401).send('Admin not found')
    admin.quotes.push(quote)
    await admin.save()
    return res.status(201).send({ quote })
  } catch (e) {
    console.log(e.message)
    return res.status(501).send({ message: e.message })
  }
}
export const updateQuote = async (req, res) => {
  const id = req.params.id
  const updatedInfo = req.body
  console.log("id ",id)
  try {
    const quote = await QuoteModel.findById(id)
    console.log("found quote");
    console.log(quote);
    if (quote) {
      await QuoteModel.findOneAndUpdate({_id:quote._id}, updatedInfo,{returnOriginal:false})
      console.log("update success");
      return res
        .status(204)
        .send({ message: `Quote with quote id ${id} has been updated.` })
    } else {
      res
        .status(404)
        .send({ message: `Quote with quote id ${id} was not found` })
    }
  } catch (e) {
    console.log("error ",e.message);
    return res.status(501).send({ mesage: e.message })
  }
}

export const deleteQuote = async (req, res) => {
  const id = req.params.id
  try {
    const quote = await QuoteModel.findById(id)
    const admin = await BaseUserModel.findOne({ role: 'admin' })
    if (!admin) return res.status(401).send('Admin not found')
    if (!quote)
      return res
        .status(404)
        .send({ message: `Quote with id ${id} was not found` })
    await QuoteModel.findByIdAndDelete(id)
    const index = admin.quotes.indexOf(quote)
    admin.quotes.splice(index, 1)
    await admin.save()
    await admin.save()
    return res
      .status(204)
      .send({ message: `Quote with id ${id} has been deleted` })
  } catch (e) {
    return res.status(501).send({ message: e.message })
  }
}

export const addToMyFavorites = async (req, res) => {
  const id = req.params.id
  console.log("request is comming");
  console.log("user id ",id);
  const { quoteId } = req.body
  console.log("quote id ",quoteId);
  try {
    const favorteQuoteId = mongoose.Types.ObjectId(quoteId)
    const appuser = await BaseUserModel.findById(id)
    if (appuser) {
      const favorite = await QuoteModel.findById(favorteQuoteId)
      if (!favorite)
        return res
          .status(404)
          .send({ message: `Quote with id ${id} was not found` })

      appuser.favorites.push(favorteQuoteId)
      await appuser.save()
      return res.status(201).send({ message: `Favorite for user added` })
    } else {
      return res
        .status(404)
        .send({ message: `App User with id ${id} was not found` })
    }
  } catch (e) {
    return res.status(501).send({ message: e.message })
  }
}

export const removeFromMyFavorites = async (req, res) => {
  const id = req.params.id
  const { quoteId } = req.body
  console.log("remove favorite is comming");
  try {
    const favorteQuoteId = mongoose.Types.ObjectId(quoteId)
    const appuser = await BaseUserModel.findById(id)
    const quote = await QuoteModel.findById(favorteQuoteId)    
    if (!quote)
      return res
        .status(404)
        .send({ message: `Quote with id ${favorteQuoteId} was not found` })
    if (appuser) {
      const index = appuser.favorites.indexOf(favorteQuoteId)
      console.log("app user",appuser);
      console.log("quote is ",favorteQuoteId);
      console.log("index ",index);
      if (index > -1) {
        appuser.favorites.splice(index, 1)
        await appuser.save()
      } else {
        return res.status(404).send({
          message: `User with id ${id} has no favorite with id ${favoriteQuoteId}`,
        })
      }
      console.log("remove is succeeded");
      return res.status(204).send({ message: `Favorite for user removed` })
    } else {
      return res
        .status(404)
        .send({ message: `App User with id ${id} was not found` })
    }
  } catch (e) {
    return res.status(501).send({ message: e.message })
  }
}

export const getFavorites = (req, res) => {
  if (res.user) {
   var quotes = res.user.favorites;
   var favorites = [];
   console.log("quotes ",quotes);
   if(quotes.length)
   quotes.map(async(item,index)=>{
     var quote = await QuoteModel.findById(item);
     favorites.push(quote);
     if(index == quotes.length - 1){
       return res.status(200).send({favorites});
     }
   })
   else return res.status(200).send({favorites})
  }else{
    return res.status(404).send({message:"user not found"})
  }
}