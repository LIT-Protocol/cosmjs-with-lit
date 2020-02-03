import { AminoTx } from "@cosmwasm/sdk";
import { Amount, Fee, FullSignature, PubkeyBundle, SignedTransaction, UnsignedTransaction } from "@iov/bcp";
import { Decimal } from "@iov/encoding";
import amino from "@tendermint/amino-js";
import { TokenInfos } from "./types";
export declare function encodePubkey(pubkey: PubkeyBundle): amino.PubKey;
export declare function decimalToCoin(lookup: TokenInfos, value: Decimal, ticker: string): amino.Coin;
export declare function encodeAmount(amount: Amount, tokens: TokenInfos): amino.Coin;
export declare function encodeFee(fee: Fee, tokens: TokenInfos): amino.StdFee;
export declare function encodeFullSignature(fullSignature: FullSignature): amino.StdSignature;
export declare function buildUnsignedTx(tx: UnsignedTransaction, tokens: TokenInfos): AminoTx;
export declare function buildSignedTx(tx: SignedTransaction, tokens: TokenInfos): AminoTx;
