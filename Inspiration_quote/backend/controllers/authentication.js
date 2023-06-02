import { BaseUserModel } from '../models/baseUser.js'
import AdminModel from '../models/admin.js'
import bcryptjs from 'bcryptjs'
import jwt from 'jsonwebtoken'
import AppUserModel from '../models/appUser.js'

export const getAllUsers = async (req, res) => {
  console.log('Request is comming')
  try {
    const allusers = await BaseUserModel.find()
    res.status(200).json({ allusers })
  } catch (error) {
    res.status(404).json({ message: error.message })
  }
}

export const getSingleUser = (req, res) => {
  if (res.user) {
    res.send(res.user)
  }
}
export const signUp = async (req, res) => {
  try {

    const { email, confirmPassword, password, role } = req.body
    if (!(email && password && confirmPassword && role)) {
      console.log('All fields are required')
      return res.status(403).send('All fields are required')
    }
    const ifExists = await BaseUserModel.findOne({ email })
    const admin = await BaseUserModel.findOne({ role : "admin" })
    if (admin  && role === "admin") return res.status(401).send({ message: 'Admin exists' })
    if (ifExists) {
      console.log('Account already exists.')
      return res.status(403).send('User allready exists')
    }
    console.log("test");
    if (password !== confirmPassword) {
      console.log("Password doesn't match")
      return res.status(403).send("Password doesn't match")
    }
    const hashedPassword = await bcryptjs.hash(password, 12)
    const newUser = req.body
    newUser.password = hashedPassword
    try {
      console.log(`role ${newUser.role}`)
      if (newUser.role !== 'admin' && newUser.role !== 'appuser') {
        console.log('role invalid')
        return res.status(403).json({ message: 'role invalid' })
      }
      if (newUser.role === 'admin') {
        const createdUser = await AdminModel.create(newUser)
        console.log('Register success')
        res.status(201).json({ createdUser })
      }
      if (newUser.role === 'appuser') {
        console.log('Register success')
        const createdUser = await AppUserModel.create(newUser)
        return res.status(201).json({ createdUser })
      }
    } catch (err) {
      console.log(err.message)
      return res.send(err.message)
    }
  } catch (error) {
    console.log("Error ",error.message);
    return res.status(500).send(error.message)
  }
}
export const login = async (req, res) => {  
  try {
    const { email, password } = req.body
    if (!(email && password)) {
      return res.status(400).send('All fields are required')
    }
    const currentUser = await BaseUserModel.findOne({ email })
    if(!currentUser){
      console.log("user not found");
      return res.status(401).send({message:"Email or Password not corrent"})
    }
    console.log("current user",currentUser);
    const comparePassword = await bcryptjs.compare(
      password,
      currentUser.password,
    )
    console.log(`Compare password is ${comparePassword}`)
    if (currentUser && comparePassword) {
      const Generate_Token = jwt.sign(
        { currentUser },
        process.env.ACCESS_TOKEN_SECRET,
        {
          expiresIn: '48h',
        },
      )
      console.log('Login success')
      res.status(200).json({ accessToken: Generate_Token, user: currentUser })
    } else {
      return res.status(400).json({ message: 'email or password not correct' })
    }
  } catch (error) {
    console.log("Error ",error.message);
    return res.status(400).json({ message: 'email or password not correct' })
  }
}
export const updateProfile = async (req, res) => {
  console.log(`res user ${res.user}`)
  try {
    const updateInfo = req.body
    const currentInfo = res.user
    console.log(currentInfo)
    if (currentInfo) {
      await BaseUserModel.findOneAndUpdate(currentInfo, { $set: updateInfo })
      res.status(201).send('Account Updated!')
    }
  } catch (error) {
    res.status(500).json({ message: error.message })
  }
}
export const deleteProfile = async (req, res) => {
  //   console.log(res.user)
  try {
    const checkUser = res.user
    if (checkUser) {
      console.log('check user found')
      await BaseUserModel.findOneAndDelete(checkUser)
      return res.status(200).send('user successfully deleted')
    }
  } catch (err) {
    res.status(500).json({ message: err.message })
  }
}
