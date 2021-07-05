import React from 'react';
import Dialog from '@material-ui/core/Dialog';
import Slide from '@material-ui/core/Slide';
import GoodShortUrlPan from './GoodShortUrlPan'; 
import ErrorShortUrlPan from './ErrorShortUrlPan';

const Transition = React.forwardRef(function Transition(props, ref) {
  return <Slide direction="up" ref={ref} {...props} />;
});

// Base Dialog skeleton. it can hold GoodHortUrlPan or ErrorShortUrlPan
// based on status code from POST API call.
const ShortUrlDialog = ({shortUrlData, onClose}) => {

  // handler to close the dialog 
  const handleClose = (event, reason) => {
    // prevent closing the dialog when click outside of the dialog
    if (reason !== 'backdropClick') {
      onClose(event, reason);
    }
  };

  return (
    <div>
      <Dialog open={true} onClose={handleClose} 
        TransitionComponent={Transition} 
        aria-labelledby="form-dialog-title"
      >
        {shortUrlData.status === 200 ? 
          <GoodShortUrlPan shortUrlData={shortUrlData} onClose={onClose}/> 
          : <ErrorShortUrlPan shortUrlData={shortUrlData} onClose={onClose}/>}
      </Dialog>
    </div>
  );
}

export default ShortUrlDialog;