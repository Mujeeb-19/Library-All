import { Request } from 'express';

export interface ParamsWithId {
    bookId: string;
}

export type RequestWithId = Request<ParamsWithId>;
vctyubji