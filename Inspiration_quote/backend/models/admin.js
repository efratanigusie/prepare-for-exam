import mongoose from 'mongoose'
import { BaseUserModel } from './baseUser.js'
const Schema = mongoose.Schema
const AdminModel = BaseUserModel.discriminator(
  'Admin',
  new Schema({
    quotes: [
      {
        type: Schema.Types.ObjectId,
        ref: 'Quote',
      },
    ],
  }),
)
export default AdminModel
