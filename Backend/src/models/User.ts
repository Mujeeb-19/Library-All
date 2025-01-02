import mongoose, { Schema, Document } from 'mongoose';

export interface IUser extends Document {
  username: string;
  password: string;
  role: string;
}

const UserSchema: Schema = new Schema({
  username: {
    type: String,
    required: true,
    unique: true, // for unique usernames
  },
  password: {
    type: String,
    required: true,
  },
  role: {
    type: String,
    default: 'patron', 
  },
});

export default mongoose.model<IUser>('User', UserSchema);
