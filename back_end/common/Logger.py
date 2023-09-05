###
# PURPOSE: This Logger class will be used to log all the exceptions occurred across this
#          entire program. The Logger class will format the error with error type, 
#          error message and a full traceback of the error or exception.

import logging
import traceback

class Logger:

    def __init__(self):
        # Setting up the logger
        self.logger = logging.getLogger(__name__)
        self.logger.setLevel(logging.ERROR)

        # You can adjust the format as needed
        formatter = logging.Formatter('%(asctime)s [%(levelname)s]: %(message)s')
        
        # Console handler to print logs to the console
        ch = logging.StreamHandler()
        ch.setFormatter(formatter)
        self.logger.addHandler(ch)
        

    @staticmethod
    def format_exception(e, function_name=''):
        error_type = type(e).__name__
        error_message = str(e)
        stack_trace = traceback.format_exc()
        return f"Error in {function_name}: {error_type} - {error_message}\n{stack_trace}"

    def log_exception(self, e, function_name=''):
        error_details = self.format_exception(e, function_name)
        self.logger.error(error_details)


           