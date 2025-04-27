import express, { Request, Response } from 'express';
import bodyParser from 'body-parser';
import * as dotenv from 'dotenv';
import mongoose from 'mongoose';
import cors from 'cors';

import bookRoutes from './routes/bookRoutes';
import userRoutes from './routes/userRoutes'; 

dotenv.config();
const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());

// routesRegisterating
app.use('/api', userRoutes);
app.use('/api', bookRoutes);

app.get('/', (req: Request, res: Response) => {
  res.send('Library Management System Backend with Auth');
});

// Connecting MongoDB
mongoose
  .connect(process.env.MONGO_URI || '')
  .then(() => console.log('Connected to MongoDB'))
  .catch((err) => {
    console.error('MongoDB connection error:', err.message);
    process.exit(1);
  });

// StartServerHere
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
