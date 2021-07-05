import React from 'react';
import Button from '@material-ui/core/Button';
import Box from '@material-ui/core/Box';
import Grid from '@material-ui/core/Grid';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import CloseIcon from '@material-ui/icons/Close';

// Dialog contents pan for rendering error server data.
const ErrorShortUrlPan = ({shortUrlData, onClose}) => {
  return (
    <>
      <DialogTitle id="form-dialog-title">
        <Box fontSize={17} fontWeight="fontWeightBold" m={0}>
          {shortUrlData.statusText ? shortUrlData.statusText : "Error!" }
        </Box>
      </DialogTitle>
      <DialogContent>
        <Grid container spacing={1}>
          <Grid item xs={12} >
              Failed to create Short URL...
          </Grid>
        </Grid>
      </DialogContent>
      <DialogActions>
        <Button onClick={() => {onClose(false)}} 
          variant="contained" color="primary" startIcon={<CloseIcon />}
        >
          Close
        </Button>
      </DialogActions>
    </>
  );
}

export default ErrorShortUrlPan;