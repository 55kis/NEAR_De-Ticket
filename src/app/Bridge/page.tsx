/* eslint-disable react/no-unescaped-entities */
// src/app/components/Home.tsx

import React, { useState } from "react";

const Bridge = () => {

    return (
        <div className="flex flex-col items-center p-6">
            <div className="w-full max-w-md bg-white rounded-lg  px-8">
                <h1 className="text-3xl font-bold text-center pt-4 bg-gradient-to-r from-sky-300 to-slate-400
                    text-transparent bg-clip-text">Bridge</h1>
                <div className='flex justify-center p-6 mb-4 '> 
                    <div className='  bg-sky-950 w-40 h-14 p-2 rounded-lg'>
                        <p className='text-white font-thin text-xs'>From</p>
                        <div className="text-white font-bold text-xl">Near</div>
                     </div>
                    <div className="w-10">

                    </div>
                    <div className='  bg-sky-950 w-40 h-14 p-2 rounded-lg'>
                        <p className='text-white font-thin text-xs'>to</p>
                        <div className="text-white font-bold text-xl">Ethereum</div>
                    </div>

                </div>
                <form >
                    <div className="flex justify-between bg-sky-950 w-full h-14 p-2 rounded-lg mb-6">
                        <div className=''>
                            <p className='text-white font-thin text-xs'>transfer</p>
                            <div className="text-white font-bold text-xl">USDC</div>
                        </div>
                        <input type="text" placeholder="0" className="bg-sky-950 font-bold text-2xl w-40  outline-none focus:text-white " />

                    </div>
                    <button className="block bg-indigo-500 rounded-lg w-full text-white p-2 mb-12">
                        Bridge 
                    </button>
                </form>

                
            </div>
            
        </div>
    );
};


export default Bridge;
