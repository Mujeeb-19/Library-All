import mongoose, { Schema, Document } from 'mongoose';

export interface Book extends Document {
    title: string;
    author: string;
    publicationDate: Date;
    quantity: number;
}

const BookSchema: Schema = new Schema({
    title: { type: String, required: true },
    author: { type: String, required: true },
    publicationDate: { type: Date, required: true },
    quantity: { type: Number, required: true },
});

BookSchema.index({ title: 1 }); 
BookSchema.index({ author: 1 }); 

export default mongoose.model<Book>('Book', BookSchema);
