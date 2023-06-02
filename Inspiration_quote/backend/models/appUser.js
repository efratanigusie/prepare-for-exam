import mongoose from 'mongoose'
const Schema = mongoose.Schema

import { BaseUserModel } from './baseUser.js'
const AppUserModel = BaseUserModel.discriminator(
  'AppUSer',
  new Schema({
    favorites: [
      {
        type: Schema.Types.ObjectId,
        ref: 'Quote',
      },
    ],
  }),
)
export default AppUserModel
