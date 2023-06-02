import mongoose from 'mongoose'
const Schema = mongoose.Schema
const QuoteSchema = new Schema(
  {
    body: {
      type: String,
      required: true,
    },
    author: {
      type: String,
      required: true,
    },
    category: {
      type: String,
      required: true,
    },
  },
  { collection: 'quotes' },
  { timestamps: true },
)

const QuoteModel = mongoose.model('Quote', QuoteSchema)
export default QuoteModel
