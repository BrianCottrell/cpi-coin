import * as React from "react";
import { Box, Button, Divider, Grid, Typography, Link } from "@mui/material";

import { useInput } from "@/hooks/useInput";
import { useContractKit } from "@celo-tools/use-contractkit";
import { useEffect, useState } from "react";
import { useSnackbar } from "notistack";
import { truncateAddress } from "@/utils";
import { PureGovernanceToken } from "../../hardhat/types/PureGovernanceToken";

export function PureGovernanceTokenContract({ contractData }) {
  const { kit, address, network, performActions } = useContractKit();
  const [greeterValue, setGreeterValue] = useState<string | null>(null);
  const [greeterInput, setGreeterInput] = useInput({ type: "text" });
  const [contractLink, setContractLink] = useState<string>("");
  const { enqueueSnackbar, closeSnackbar } = useSnackbar();

  const contract = contractData
    ? (new kit.web3.eth.Contract(
        contractData.abi,
        contractData.address
      ) as any as PureGovernanceToken)
    : null;

  useEffect(() => {
    if (contractData) {
      setContractLink(`${network.explorer}/address/${contractData.address}`);
    }
  }, [network, contractData]);

  const convertToGovToken = async () => {
    try {
      await performActions(async (kit) => {
        const gasLimit = await contract.methods
          .convertToPure(greeterInput as int)
          .estimateGas();

        const result = await contract.methods
          .convertToGovToken(greeterInput as int)
          //@ts-ignore
          .send({ from: address, gasLimit });

        console.log(result);

        const variant = result.status == true ? "success" : "error";
        const url = `${network.explorer}/tx/${result.transactionHash}`;
        const action = (key) => (
          <>
            <Link href={url} target="_blank">
              View in Explorer
            </Link>
            <Button
              onClick={() => {
                closeSnackbar(key);
              }}
            >
              X
            </Button>
          </>
        );
        enqueueSnackbar("Transaction processed", {
          variant,
          action,
        });
      });
    } catch (e) {
      enqueueSnackbar(e.message, {variant: 'error'});
      console.log(e);
    }
  };

  return (
    <Grid sx={{ m: 1 }} container justifyContent="center">
      <Grid item sm={6} xs={12} sx={{ m: 2 }}>
        <Typography variant="h5">Pure Governance Token Contract:</Typography>
        {contractData ? (
          <Link href={contractLink} target="_blank">
            {truncateAddress(contractData?.address)}
          </Link>
        ) : (
          <Typography>No contract detected for {network.name}</Typography>
        )}
        <Divider sx={{ m: 1 }} />

        <Typography variant="h6">Write Contract</Typography>
        <Box sx={{ m: 1, marginLeft: 0 }}>{setGreeterInput}</Box>
        <Button sx={{ m: 1, marginLeft: 0 }} variant="contained" onClick={convertToGovToken}>
          Convert To Pure Token
        </Button>
        <Divider sx={{ m: 1 }} />

        <Typography variant="h6">Read Contract</Typography>
        <Typography sx={{ m: 1, marginLeft: 0, wordWrap: "break-word" }}>
          Contract Result: {greeterValue}
        </Typography>
      </Grid>
    </Grid>
  );
}
