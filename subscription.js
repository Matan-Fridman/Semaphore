const {SemaphoreEthers} = require("@semaphore-protocol/data")
const { Group } = require ("@semaphore-protocol/group")
const { generateProof, verifyProof} = require ("@semaphore-protocol/proof")
const {ethers} = require("ethers")

const semaphoreEthers = new SemaphoreEthers("http://3.22.38.202:8545", {
    address: "0xf7C339C5520f6800266227878A6A44Db4eEc35C4"
})

const provider = new ethers.JsonRpcProvider("http://3.22.38.202:8545")
const wlt = new ethers.Wallet("0dbc2427bcc0c03b4d7568f0ac135b543633c237d06837e8ff6dabc8ca69b3ae", provider)
async function main(){
  const payboxContract = new ethers.Contract("0xf7C339C5520f6800266227878A6A44Db4eEc35C4", [{}], wlt)
  const identity = Identity("e6d8b796a4d35d6b7c3461048ec2e7a0f9d48a61d9d19063f95bcbf384d21330")
  const members = await semaphoreEthers.getGroupMembers("75")
  const group = new Group(members)
  const proof = await generateProof(identity, group, 0, publicNullifier)
  const tx = await payboxContract.addAmountToBox(proof, 75, 102)
  console.log("withdrawing funds...")
  await tx.wait()
  await verifyProof()
}
main()