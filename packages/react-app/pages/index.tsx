import * as React from "react";
import { Tabs, Tab, Typography, Box, Link } from "@mui/material";
import deployedContracts from "../../hardhat/deployments/hardhat_contracts.json";
import { useContractKit } from "@celo-tools/use-contractkit";
import {
  PureTokenContract,
  PureGovernanceTokenContract,
  StorageContract,
  GreeterContract,
  ButtonAppBar
} from "@/components";

interface TabPanelProps {
  children?: React.ReactNode;
  index: number;
  value: number;
}

export default function App() {
  const { network } = useContractKit();
  const [value, setValue] = React.useState(0);

  const handleChange = (event: React.SyntheticEvent, newValue: number) => {
    setValue(newValue);
  };

  const contracts =
    deployedContracts[network?.chainId?.toString()]?.[
      network?.name?.toLocaleLowerCase()
    ]?.contracts;

    console.log(contracts)

  return (
    <div>
      <ButtonAppBar />
      <Box sx={{ width: "100%" }}>
        <Box sx={{ borderBottom: 1, borderColor: "divider" }}>
          <Tabs value={value} onChange={handleChange} aria-label="basic tabs">
            <Tab label="Pure Token" {...a11yProps(0)} />
            <Tab label="Pure Governance Token" {...a11yProps(1)} />
          </Tabs>
        </Box>
        <TabPanel value={value} index={0}>
          <PureTokenContract contractData={contracts?.PureToken} />
        </TabPanel>
        <TabPanel value={value} index={1}>
          <PureGovernanceTokenContract contractData={contracts?.PureGovernanceToken} />
        </TabPanel>
      </Box>
    </div>
  );
}

function TabPanel(props: TabPanelProps) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          <Typography component="div">{children}</Typography>
        </Box>
      )}
    </div>
  );
}

function a11yProps(index: number) {
  return {
    id: `simple-tab-${index}`,
    "aria-controls": `simple-tabpanel-${index}`,
  };
}
