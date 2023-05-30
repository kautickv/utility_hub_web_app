

async function sendVerifyAPIToAuthenticationServer(jwtToken){

    /*
    PURPOSE: Send an HTTP POST request to the verify endpoint to check if user is logged in.
    INPUT: JWT Token as string
    OUTPUT: returns the status code of the response. If error, returns 500 error
    */

    try{
        let response = await fetch(`${process.env.REACT_APP_API_GATEWAY_BASE_URL}/auth/verify`,{
            method: 'POST',
            headers:{
                'Content-Type':'application/json',
                'Authorization': 'Bearer ' + jwtToken?.trim() ?? ''
            },
        });

        return response.status;
       
    }catch(err){
        console.log(`An error occurred sending verify API. ${err}`);
        return 500;
    }
    
}

module.exports={sendVerifyAPIToAuthenticationServer};