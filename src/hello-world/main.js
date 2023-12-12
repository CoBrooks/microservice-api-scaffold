/**
 * @callback APIGatewayHandler
 * @param {AWSLambda.APIGatewayProxyEventV2} event
 * @param {AWSLambda.Context} context
 * @returns {Promise<AWSLambda.APIGatewayProxyResultV2>}
 */

/**
 * @param {number} statusCode
 * @param {any} body
 * @returns {AWSLambda.APIGatewayProxyResultV2}
 */
const httpResponse = (statusCode, body) => {
  return {
    statusCode,
    body: JSON.stringify(body)
  };
};

/**
 * AWS Lambda entry point
 *
 * @type {APIGatewayHandler}
 */
export const handler = async (event) => {
  console.log("Hello, World!");

  return httpResponse(200, { message: "Hello, World!", event });
};
