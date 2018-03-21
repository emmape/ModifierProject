//import { Observable } from 'rxjs/Observable'
//import { Injectable } from '@angular/core';
//import { Subject } from 'rxjs/Subject';
//import { GiftCard } from '../models/giftCard.model'
//import { Http } from '@angular/http'


//@Injectable()
//export class GiftCardService {
//  giftCard: GiftCard[] = [];
//  ValueCode: string;
//  Amount: string;
//  Buyer: string;
//  BuyingDate: string;
//  Redeemer: string;
//  RedeemingDate: string;
//  Redeemed: string;
//  RecieverName: string;


//  constructor(private _httpService: Http) { }

//  getGiftCards(): GiftCard[] {
//    //this.giftCard = [];
//    this._httpService.get('/api/GiftCard/data').subscribe(values => {

//      for (let i of values.json()) {
//        this.ValueCode =i.valueCode;
//        this.Amount = i.amount;
//        this.Buyer = i.buyerId;
//        this.BuyingDate = i.valueCode;

//        this.Redeemer = i.redeemerId;
//        this.RedeemingDate =i.redeemingDate;
//        this.Redeemed = i.redeemed;
//        this.RecieverName = i.recieverName;

//        //this.giftCard.push({ valueCode: this.ValueCode, amount: Number(this.Amount), buyerID: Number(this.Buyer), buyingDate: this.BuyingDate, redeemerID: Number(this.Redeemer), redeemingDate: this.RedeemingDate, redeemed: Boolean(this.Redeemed), recieverName: this.RecieverName })

//      }

      
//    });

//    return this.giftCard;
    
//  }

//  getGiftCard(valueCode: string): Promise<GiftCard>  {
//    ////console.log(User.Identity.Name);
//      const post: any = this._httpService.get('/api/GiftCard/' + valueCode);
//    return post.toPromise()
//        .then((response: any)=> response.json());
//  }
//  //getGiftCard(valueCode: string) {

//  //}

//  async setRedeemed(valueCode: string) {
//    const req = await this._httpService.post('/api/GiftCard/redeem/' + valueCode, null);
//    req.subscribe();
//  }

//  async addNewGiftCard(giftCard: GiftCard): Promise<string> {
//    const req:any = await this._httpService.post('/api/GiftCard', giftCard);
//    return req.toPromise().then((response: any) => response.json().valueCode);
//  }
  
//  //async addNewGiftCard(valueCode: GiftCard) {

//  //}

//}
