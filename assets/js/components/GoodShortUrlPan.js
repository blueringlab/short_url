import React from 'react';
import Button from '@material-ui/core/Button';
import Box from '@material-ui/core/Box';
import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import FileCopyIcon from '@material-ui/icons/FileCopy';
import CloseIcon from '@material-ui/icons/Close';

// Dialog contents pan for rendering successful server data.
const GoodShortUrlPan = ({shortUrlData, onClose}) => {
  // handler to copy full-short-url to clipboard
  const copyCodeToClipboard = (evt) => {
    evt.preventDefault();

    const el = document.getElementById("full-url")
    el.select()
    document.execCommand("copy")
  }

  return (
    <>
      <DialogTitle id="form-dialog-title">Created Short URL!!</DialogTitle>
      <DialogContent>
        <Grid container spacing={1}>
          <Grid item xs={12} >
          <TextField id="full-url" variant="filled" fullWidth 
            defaultValue={shortUrlData.data.fullUrl}
            InputProps={{
              readOnly: true,
            }}
            />
          </Grid>
          <Grid item xs={12}>
            <Box fontSize={12} fontWeight="fontWeightLight" m={0}>
              {shortUrlData.data.url}
            </Box>
          </Grid>

        </Grid>
      </DialogContent>
      <DialogActions>
        <Button onClick={copyCodeToClipboard}             
          variant="contained" color="primary" startIcon={<FileCopyIcon />}
        >
          Copy to Clipboard
        </Button>
        <Button onClick={() => {onClose(true)}} 
          variant="contained" color="primary" startIcon={<CloseIcon />}
        >
          Close
        </Button>
      </DialogActions>
    </>
  );
}

export default GoodShortUrlPan;