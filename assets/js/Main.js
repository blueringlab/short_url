import React from 'react';
import Button from '@material-ui/core/Button';
import CssBaseline from '@material-ui/core/CssBaseline';
import TextField from '@material-ui/core/TextField';
import Grid from '@material-ui/core/Grid';
import Container from '@material-ui/core/Container';
import Box from '@material-ui/core/Box';
import Create from '@material-ui/icons/Create';
import { useState } from 'react';

import axios from 'axios';
import validator from 'validator';

import useStyles from './styles';
import ShortUrlDialog from './components/ShortUrlDialog';

const shortUrlApi = axios.create({
  baseURL: `http://localhost:4000/api/`,
  headers: {
    'Content-Type': 'application/json;charset=UTF-8'
  }
})

const Main = () => {
  const classes = useStyles();

  // short url dialog state true: open, false: closed (hidden)
  const [shortUrlDialogVisible, setShortUrlDialogVisible] = useState(false);
  // short url data state from server API
  const [shortUrlData, setShortUrlData] = useState({});

  // long url state from UI, Long URL textfield entry
  const [longUrl, setLongUrl] = useState('');
  // form valid state. true: form is valid and ready for submit, false: form contains invalid data
  const [validForm, setValidForm] = useState(false);

  // handler to perform open dialog
  const handleDialogOpen = () => {
    setShortUrlDialogVisible(true);
    console.log("ShortUrlDialog opened.");
  };

  // handler to perform close dialog
  const handleDialogClose = (clearLongUrl) => {
    console.log("handleDialogClose clearLongUrl=", clearLongUrl);
    if (clearLongUrl === true) { 
      setLongUrl("");
      setValidForm(false);
    }
    
    setShortUrlDialogVisible(false);
    console.log("ShortUrlDialog closed.");
  };

  // handler whenever long url value changed
  const updateLongUrl = (updatedLongUrl) => {
    validator.isURL(updatedLongUrl) ? setValidForm(true) : setValidForm(false);
    setLongUrl(updatedLongUrl);
  }

  // handler to submit creating short url POST request
  const submitShortUrl = (evt) => {
    evt.preventDefault();

    console.log("submitShortUrl url=", longUrl);

    shortUrlApi.post("/url", 
          { url: longUrl }, 
          { validateStatus: false }).then((res)=> {
        console.log(res);
        setShortUrlData(res);
        handleDialogOpen();
    })
  }

  return (
    <Container component="main" maxWidth="md">
      <CssBaseline />
      <div className={classes.paper}>
        <Box fontSize={26} fontWeight="fontWeightBold" m={0}>
        Enter a long URL to make a Short URL
        </Box>
        <form className={classes.form} onSubmit={submitShortUrl}>
        <Grid container spacing={2}>
            <Grid item xs={12}>
              <TextField id="url" variant="outlined" required fullWidth
                  label="Long URL" name="url" value={longUrl}
                  error={longUrl !== "" && !validForm}
                  helperText={longUrl !== "" && !validForm ? "Invalid URL" : ""}
                  onChange={(evt) => updateLongUrl(evt.target.value) } />
            </Grid>
          </Grid>
          <Button
            type="submit"
            fullWidth
            variant="contained"
            color="primary"
            className={classes.submit} 
            startIcon={<Create />}
            disabled={!validForm}
          >
            <Box fontSize={17} fontWeight="fontWeightBold" m={0}>
              Make Short URL!
            </Box>
          </Button>
          {shortUrlDialogVisible ? 
            <ShortUrlDialog shortUrlData={shortUrlData} onClose={handleDialogClose}/> 
            : <Box></Box>
          }
        </form>
      </div>
    </Container>
  );
}

export default Main;